/**
 * Created by baultik on 2/2/17.
 */

/**
 * Global variables
 */
var embedPreview = null;
var timer = null;
var userWatchList = [];

$(document).ready(function () {
    embedPreview = new Preview();
    embedPreview.init();
    var body = $("body");

    body.on('click', '.grid-item', (function (event) {
        stopPropagation(event);
        updatePreview(this);
        if ($('.login_menu').css('display') != 'none') {
            $(".login_menu").addClass("hide");
        }
    }));

    body.on('click', '.grid-item-f', (function (event) {
        stopPropagation(event);
        updatePreview(this);
        if ($('.login_menu').css('display') != 'none') {
            $(".login_menu").addClass("hide");
        }
    }));

    $("#add_watch").on('click touchend', function (event) {
        stopPropagation(event);
        getFavorite();
    });

    $("#dropdown1").on('click touchend', (function (event) {
        // stopPropagation(event);
        event.stopPropagation();
    }));

    $(window).resize(function () {
        onResize(500, updateFullScreen);
    })
});

/**
 * toggles favorites on/off and adds class to change colors
 */
function getFavorite() {
    var channel = embedPreview.data.channel;
    var category = embedPreview.data.category;
    if (uid !== null) {
        if ($('.add_watch_icon').text() == 'visibility_off') {
            $('.add_watch_icon').text("visibility").css("background-color", "#ff9800");
        } else {
            $('.add_watch_icon').text("visibility_off").css("background-color", "lightgrey");
        }
        addToWatch(channel, category);
    }
}
/**
 * checks if item is in user's watchlist on firebase and adjusts class accordingly
 */
function checkWatchStatus(item) {
    var foundItem = item.channel;
    var foundKey = null;
    if (uid !== null) {
        for (var key in userWatchList) {
            if (key == foundItem) {
                foundKey = foundItem
            }
        }
        if (foundKey !== null) {
            $('.add_watch_icon').text("visibility").css("background-color", "#ff9800")
        } else {
            $('.add_watch_icon').text("visibility_off").css("background-color", "lightgrey");
        }
    } else {
        $('.add_watch_icon').text("visibility_off").css("background-color", "lightgrey");
    }
}
/**
 * updates preview to whichever thumbnail was clicked on
 */
function updatePreview(parent) {
    var index = $(parent).attr('data-index');
    var item = main_array[index];
    if (uid !== null) {
        $("#add_watch").show();
        checkWatchStatus(item);
    } else {
        $("#add_watch").hide();
    }
    embedPreview.play(item);
}
/**
 * adds channel name to user's table on firebase
 */
function addToWatch(channel, category) {
    if (uid !== null) {
        var new_channel = {};
        var foundKey = null;
        for (var key in userWatchList) {
            if (key == channel) {
                foundKey = key;
            }
        }
        if (foundKey === null) {
            new_channel[channel] = category;
            fb_ref.ref("users/" + uid + "/watchList").update(new_channel);
        } else {
            fb_ref.ref("users/" + uid + "/watchList").child(foundKey).remove();
        }
    }
}
/**
 * checks user's table on firebase against currently live videos
 */
function find_watched_videos() {
    $("#dropdown1 *").remove();
    create_watch_list(userWatchList);
}
/**
 * builds list of channels and attaches click handlers that play a video if it is currently live or the ability to remove the video from list
 */
function create_watch_list(user_watch_list) {
    var ul_title = $("<li>").text("Channel Watch List").addClass("ul_title");
    $("#dropdown1").append(ul_title);
    for (var key in user_watch_list) {
        var live_chip = $("<div>").addClass("chip live_chip").text("Live!").addClass(user_watch_list[key]);
        var video_title_link = $("<li>").data("channel", key);
        var video_title = $("<div>").text(key).addClass("watch_list_text");
        var remove_watch_btn = $("<button>").addClass("btn-floating remove_btn")
            .text("x")
            .data("channel", key);
        video_title_link.append(video_title);
        video_title_link.append(remove_watch_btn);
        $("#dropdown1").append(video_title_link);
        remove_watch_btn.click(function () {
            checkWatchStatus($(this).data("channel"));
            fb_ref.ref("users/" + uid + "/watchList")
                .child($(this).data("channel"))
                .remove();
        });
        video_title_link.on('click', function (event) {
            stopPropagation(event);
            play_watch_list.call(this);
        });
        for (var i = 0; i < main_array.length; i++) {
            if (key === main_array[i].channel) {
                video_title_link.append(live_chip);
                video_title_link.addClass("live_video_now");
                $(".live_video_now").css("color", "white");
            }
        }
    }
}
/**
 * click handler for watchlist items if video is currently live
 */
function play_watch_list() {
    var video_channel = $(this).data("channel");
    for (var i = 0; i < main_array.length; i++) {
        if (main_array[i].channel == video_channel) {
            embedPreview.play(main_array[i]);
            checkWatchStatus(main_array[i]);
        }
    }
}
/**
 * creates and copies link to clipboard for video
 */
function createShareableLink() {
    var current_id = this.data.id;
    var sharable_link = 'http://www.streamism.tv?shared=' + current_id;
    if (window.clipboardData && window.clipboardData.setData) {
        // IE specific code path to prevent textarea being shown while dialog is visible.
        return clipboardData.setData("Text", current_id);

    } else if (document.queryCommandSupported && document.queryCommandSupported("copy")) {
        var textarea = document.createElement("textarea");
        textarea.textContent = sharable_link;
        textarea.style.position = "fixed";  // Prevent scrolling to bottom of page in MS Edge.
        document.body.appendChild(textarea);
        textarea.select();
        try {
            var toast_text = "Link copied to your clipboard.<br>Share it with your friends!";
            Materialize.toast(toast_text, 4000, 'rounded toasty');
            return document.execCommand("copy");  // Security exception may be thrown by some browsers.
        } catch (ex) {
            console.warn("Copy to clipboard failed.", ex);
            return false;
        } finally {
            document.body.removeChild(textarea);
        }
    }
}

function updateFullScreen() {
    embedPreview.determineLayout();

    if ($(".switch").css('display') == "none" && !$("#change_view").is(':checked')) {
        change_view();
        $("#change_view").prop("checked", true);
    }
}

function onResize(time, callback) {
    if (timer != null) {
        clearTimeout(timer);
    }
    timer = setTimeout(callback, time);
}
/**
 * initializes preview variables
 */
function Preview() {
    this.data = null;
    this.preview = $('#preview');
    this.btnContainer = $("#preview-btn-container");
    this.expandBtn = $("#open_full");
    this.contractBtn = $("#close_full");
    this.closeBtn = $("#close_preview");
    this.addWatch = $("#add_watch");
    this.shareBtn = $('#share_btn');
    this.iframeVideoElement = null;
    this.iframeChatElement = null;
    this.videoSrc = "";
    this.chatSrc = "";
    this.animationTime = 250;
    this.defaultWidth = 0;
    this.defaultHeight = 0;
    this.expandedBtnGutter = 0;
    this.minChatWidth = 400;
    this.expanded = false;
    this.mobile = false;
}
/**
 * creates iframe for chat and video
 */
Preview.prototype.init = function () {
    //get initial size
    this.defaultWidth = this.preview.width();
    this.defaultHeight = this.preview.height();

    //setup button click handlers
    this.preview.on('click touchend', '#close_preview', this.stop.bind(this))
        .on('click touchend', '#close_preview', stopPropagation);
    this.preview.on('click touchend', '#open_full', this.expand.bind(this))
        .on('click touchend', '#open_full', stopPropagation);
    this.preview.on('click touchend', '#close_full', this.contract.bind(this))
        .on('click touchend', '#close_full', stopPropagation);
    this.preview.on('click touchend', '#share_btn', createShareableLink.bind(this))
        .on('click touchend', '#share_btn', stopPropagation);


    //Create iframes
    this.iframeChatElement = $("<iframe>",
        {
            frameborder: "0",
            scrolling: "no",
            width: this.defaultWidth + "px",
            height: this.defaultHeight + "px",
            src: "about:blank"
        })
        .css({position: "absolute", display: "inline-block", left: "0", top: "0"});
    this.preview.append(this.iframeChatElement);

    this.iframeVideoElement = $("<iframe>",
        {
            frameborder: "0",
            scrolling: "no",
            width: this.defaultWidth + "px",
            height: this.defaultHeight + "px",
            src: "about:blank"
        })
        .css({position: "absolute", display: "inline-block", left: "0", top: "0"});
    this.preview.append(this.iframeVideoElement);
};
/**
 * Expand preview to fullscreen
 */
Preview.prototype.expand = function () {
    //get buttons and hide them
    this.btnContainer.hide();
    this.expandBtn.hide();
    this.contractBtn.show();
    current_state.full = this.data.id;
    current_state.preview = null;
    pushState();

    //animate position
    this.position(this.animationTime, true, function () {
        //show appropriate buttons
        this.btnContainer.show();
    });
};
/**
 * Contract preview to regular size
 */
Preview.prototype.contract = function () {
    if (!this.preview.is(":visible") || !this.expanded) return;

    //get buttons and hide them
    this.btnContainer.hide();
    this.expandBtn.show();
    this.contractBtn.hide();
    current_state.preview = this.data.id;
    current_state.full = null;
    pushState();

    //animate position
    this.position(this.animationTime, false, function () {
        //show appropriate buttons
        this.btnContainer.show();
    });
};
/**
 * Updates position of preview including view iframe and chat iframe
 * @param time animation time
 * @param expanded expand or contract boolean
 * @param callback function to call after animation is finished
 */
Preview.prototype.position = function (time, expanded, callback) {
    if (time === undefined) time = this.animationTime;
    callback = callback ? callback.bind(this) : function () {
        };
    if (expanded !== undefined) this.expanded = expanded;

    //get main div and content div and sizes
    var prevWidth = this.defaultWidth, prevHeight = this.defaultHeight;
    var contentWidth = prevWidth, contentHeight = prevHeight, contentLeft = 0;

    //set up sizes for video and chat and position for chat
    var vWidth = contentWidth, cWidth = vWidth;
    var vHeight = contentHeight, cHeight = vHeight;
    var top = 0, left = contentLeft;

    if (this.expanded) {
        //if fullscreen changes sizes to fullscreen layout
        prevWidth = $(window).width();
        prevHeight = $(window).height() - $("nav").height();
        contentWidth = prevWidth - this.expandedBtnGutter;
        contentHeight = prevHeight;
        contentLeft = this.expandedBtnGutter;
        vWidth = cWidth = contentWidth;
        vHeight = cHeight = contentHeight;
        left = contentLeft;

        //If fullscreen account for if screen is taller than wide - otherwise use default sizes with chat hidden
        if (contentHeight > contentWidth) {
            //Make video full width at appropriate aspect ratio with chat filling below
            vHeight = contentWidth * 0.5625;

            top = vHeight;
            cHeight = contentHeight - top;
        } else {
            //Make video and chat side by side
            vWidth = contentWidth - Math.min(this.minChatWidth, contentWidth / 2);

            left = vWidth + contentLeft;
            cWidth = contentWidth - vWidth;
        }
    }

    //Animate to sizes
    this.preview.animate({width: prevWidth, height: prevHeight}, time, callback);
    this.iframeVideoElement.animate({width: vWidth, height: vHeight, left: contentLeft}, time);
    this.iframeChatElement.animate({width: cWidth, height: cHeight, left: left, top: top}, time);
};
/**
 * Determine what the position should be based on size
 * @param expanded expand or contract boolean
 */
Preview.prototype.determineLayout = function (expanded) {
    if (expanded === undefined) expanded = this.expanded;

    //On mobile and smaller window sizes - only do expanded view
    if (this.defaultWidth + this.expandedBtnGutter > $(window).width()) {
        this.expandBtn.hide();
        this.contractBtn.hide();
        this.mobile = true;
        expanded = true;
    } else {
        this.mobile = false;
        this.reset();
        if (expanded) {
            this.expandBtn.hide();
            this.contractBtn.show();
        } else {
            this.expandBtn.show();
            this.contractBtn.hide();
        }
        //this.btnContainer.hide();
    }

    this.position(0, expanded);
};
/**
 * Play a stream
 * @param data the stream data object
 * @param expanded start expanded or contracted
 */
Preview.prototype.play = function (data, expanded) {
    //Get embed data
    this.data = data;
    this.videoSrc = this.data.source === "twitch" ? this.data.embedVideo :
        this.data.embedVideo + "?&autoplay=1&fs=1&modestbranding=1&playsinline=1&rel=0";
    this.chatSrc = this.data.embedChat;

    this.iframeVideoElement.attr("src", this.videoSrc);
    this.iframeChatElement.attr("src", this.chatSrc);

    this.determineLayout(expanded);
    this.preview.show();

    if (this.expanded) {
        current_state.full = this.data.id;
        current_state.preview = null;
    } else {
        current_state.preview = this.data.id;
        current_state.full = null;
    }

    pushState();
    sendEvent('video', 'play', this.data.id, new Date().getTime());
};
/**
 * Stop stream and hide preview
 */
Preview.prototype.stop = function () {

    this.preview.hide();
    this.iframeVideoElement.attr("src", "about:blank");
    this.iframeChatElement.attr("src", "about:blank");

    current_state.full = null;
    current_state.preview = null;
    pushState();
    //reset to initial state
    this.reset();
    sendEvent('video', 'stop', this.data.id, new Date().getTime());

};
/**
 * Reset preview to default state
 */
Preview.prototype.reset = function () {
    //reset divs and buttons
    if (!this.mobile) {
        this.preview.css({width: this.defaultWidth, height: this.defaultHeight});
        this.btnContainer.show();
        this.contractBtn.hide();
        this.expandBtn.show();
    }
};