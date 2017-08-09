/**
 * Created by baultik on 1/18/17.
 */
// Dimensions of sunburst.
var width = document.body.clientWidth;
var height = document.body.clientHeight - 100 - $("nav").height() - 30;
var radius = Math.min(width, height) / 2;
$("#sunburst_sequence_container").height(height);
$("#chart").css({"padding-top": $("nav").height() + 20 + "px"}).height(height);
$("#viewport").width(radius * 2).height(radius * 2);


var sunburst_array = [];

// Breadcrumb dimensions: width, height, spacing, width of tip/tail.
var b = {
    w: 75, h: 30, s: 3, t: 10
};
// '<span class="glyphicon glyphicon-gamepad"></span>'
// Mapping of step names to colors.
var icons = {
    "gaming": 'f11b',
    "entertainment": '<span class="glyphicons glyphicons-theater"></span>',
    "people": '<span class="glyphicons glyphicons-group"></span>',
    "news": '<span class="glyphicons glyphicons-newspaper"></span>',
    "sports": ' <span class="glyphicons glyphicons-soccer-ball"></span>',
    "misc": '<span class="glyphicons glyphicons-globe"></span>'
};

var colors = {
    "gaming": $('#gaming:checked + span').css('background-color'),
    "entertainment": $('#entertainment:checked + span').css('background-color'),
    "people": $('#people:checked + span').css('background-color'),
    "news": $('#news:checked + span').css('background-color'),
    "sports": $('#sports:checked + span').css('background-color'),
    "misc": $('#misc:checked + span').css('background-color')
};

// Total size of all segments; we set this later, after loading the data.
var totalSize = 0;

var vis = d3.select("#chart").append("svg:svg")
    .attr("width", width)
    .attr("height", height)
    .append("svg:g")
    .attr("id", "container")
    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

var partition = d3.partition()
    .size([2 * Math.PI, radius * radius]);

var arc = d3.arc()
    .startAngle(function (d) {
        return d.x0;
    })
    .endAngle(function (d) {
        return d.x1;
    })
    .innerRadius(function (d) {
        return Math.sqrt(d.y0);
    })
    .outerRadius(function (d) {
        return Math.sqrt(d.y1);
    });


// Bounding circle underneath the sunburst, to make it easier to detect
// when the mouse leaves the parent g.
vis.append("svg:circle")
    .attr("r", radius)
    .style("opacity", 0);

// Main function to draw and set up the visualization, once we have the data.
function createVisualization(json) {
    var local_array = $.extend(true, {}, json);
    for (var i = 0; i < local_array.streams.length;) {
        var obj = local_array.streams[i];
        //Filter to 50 max videos for each category
        obj.streams = obj.streams.filter(function (val, index) {
            return index < 50;
        });
        //local_array.streams[i] = obj;

        if (preferences[obj.id]) {
            i++
        } else {
            local_array.streams.splice(i, 1);
        }
    }

    var stringified = JSON.stringify(local_array).replace(/"streams":/g, '\"children\":');
    local_array = JSON.parse(stringified);

    // Turn the data into a d3 hierarchy and calculate the sums.
    var root = d3.hierarchy(local_array)
        .sum(function (d) {
            return d.viewers;
        })
        .sort(function (a, b) {
            return b.value - a.value;
        });

    // For efficiency, filter nodes to keep only those large enough to see.
    var nodes = partition(root).descendants()
        .filter(function (d) {
            var sunFilter = true;
            if (d.data.hasOwnProperty('category')) {
                sunFilter = preferences[d.data.category];
            }
            return sunFilter && (d.x1 - d.x0 > 0.005); // 0.005 radians = 0.29 degrees
        });
    var index_count = -1;
    var icon;

    var path = vis.data([local_array]).selectAll("path")
        .data(nodes);
    path.exit().remove();
    sunburst_array = [];
    var pathway = path.enter().append("svg:path")
        .merge(path)
        // path.transition()
        .attr("display", function (d) {
            sunburst_array.push(this);
            return d.depth ? null : "none";
        })

        .attr("d", arc)
        .attr("fill-rule", "evenodd")
        .attr('data-index', function (d) {
            index_count += 1;
            return index_count;
        })

        .attr('icon', function (d) {
            var icon = icons[d.data.id] || icons[d.data.category];
            var index = parseInt($(this).attr('data-index'));
            if (index > 0 && index < 7) {
                // path.append(testDiv);
                path.append('svg:foreignObject')
                    .attr("x", -8)
                    .attr("y", -8)
                    .attr("width", 20)
                    .attr("height", 20)
                    .append("xhtml:span")
                    .attr('class', icon);
            }
            return icon

        })
        .style("fill", function (d) {
            var color = colors[d.data.id] || colors[d.data.category];
            return color;
        })
        .style("opacity", 1)
        .on("mouseover", mouseover)
        .on('click',
            sun_video
        );

    path.exit().transition()
        .remove();

    // Add the mouseleave handler to the bounding circle.
    d3.select("#container").on("mouseleave", mouseleave);

    // Get total size of the tree = value of root node from partition.
    totalSize = pathway.node().__data__.value;
}

function update_graph(data) {
    var path = g.selectAll('path').data(data);
}

var savedPrefs = getPreferences();

function sun_video(d, i) {
    var index = parseInt($(this).attr('data-index'));
    var current_item_details = sunburst_array[index].__data__.data;
    if (current_item_details.hasOwnProperty('children')) {
        var prefs = getPreferences();
        var count = 0;
        for (var key in prefs) if (prefs[key]) count++;
        var sunburst_data = {};
        if (count == 1) {
            sunburst_data = savedPrefs;
        } else {
            savedPrefs = $.extend(true, {}, prefs);
            for (var j = 1; j < 7; j++) {
                var obj = sunburst_array[j].__data__.data;
                if (obj.hasOwnProperty('children')) {
                    sunburst_data[obj.id] = j == index;
                }
            }
        }

        setPreferences(sunburst_data);
    }
    else if (current_item_details.hasOwnProperty("embedVideo")) embedPreview.play(current_item_details);
}

// Fade all but the current sequence, and show it in the breadcrumb trail.
function mouseover(d) {
    var percentage = (100 * d.value / totalSize).toPrecision(3);
    var percentageString = percentage + "%";
    if (percentage < 0.1) {
        percentageString = "< 0.1%";
    }

    var v = d.data.viewers ? d.data.viewers + " viewers" : percentageString;
    //d3.select("#percentage").text(percentageString+" "+v);
    d3.select("#percentage").text(v);
    d3.select("#title").text(d.data.title || d.data.id);
    $('#thumbnail').attr('src', d.data.thumbnail || d.data.children[0].thumbnail).appendTo('#viewport');
    d3.select('#thumbnail').style("visibility", '');
    d3.select("#explanation").style("visibility", "").style("background-color", colors[d.data.id] || colors[d.data.category]);

    var sequenceArray = d.ancestors().reverse();
    sequenceArray.shift(); // remove root node from the array

    // Fade all the segments.
    d3.selectAll("path")
        .style("opacity", 0.3);

    // Then highlight only those that are an ancestor of the current segment.
    vis.selectAll("path")
        .filter(function (node) {
            return (sequenceArray.indexOf(node) >= 0);
        })
        .style("opacity", 1);
}

// Restore everything to full opacity when moving off the visualization.
function mouseleave(d) {
    // Deactivate all segments during transition.
    d3.selectAll("path").on("mouseover", null);

    // Transition each segment to full opacity and then reactivate it.
    d3.selectAll("path")
        .transition()
        .style("opacity", 1)
        .on("end", function () {
            d3.select(this).on("mouseover", mouseover);
        });

    d3.select("#thumbnail")
        .style("visibility", "hidden");
    d3.select("#explanation")
        .style("visibility", "hidden");
}

