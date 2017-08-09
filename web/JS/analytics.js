/**
 * Created by baultik on 2/20/17.
 */
/**
 * Sends a page view to analytics. Includes window.title and window.location.
 * {@link https://developers.google.com/analytics/devguides/collection/analyticsjs/pages}
 */
function sendPageView(page) {
    //Set custom path
    ga('set', 'page', page);
    ga('send', 'pageview');
}

/**
 * Sends an analytics event. {@link https://developers.google.com/analytics/devguides/collection/analyticsjs/events}
 * @param {string} category Typically the object that was interacted with. Required
 * @param {string} action The type of interaction. Required
 * @param {string} label Useful for categorizing events
 * @param {number} value A numeric value associated with the event.
 */
function sendEvent(category, action, label, value) {
    if (!category || !action) {
        console.error("Event requires both a category and an action");
        return;
    }

    var params = {
        hitType: 'event',
        eventCategory: category,
        eventAction: action
    };

    if (label != undefined) params.eventLabel = label;
    if (value != undefined) params.eventValue = value;

    ga('send', params);
}

/**
 * Set a user id so all analytics data will be associated with that id.
 * {@link https://developers.google.com/analytics/devguides/collection/analyticsjs/cookies-user-id#user_id"}
 * @param {string} uid User ID
 */
function setUserID(uid) {
    if (uid) ga('set', 'userId', uid);
}