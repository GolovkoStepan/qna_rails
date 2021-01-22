const entityMap = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
    '/': '&#x2F;',
    '`': '&#x60;',
    '=': '&#x3D;'
};

function escapeHtml(string) {
    return String(string).replace(/[&<>"'`=\/]/g, function (s) { return entityMap[s]; });
}

function loadGist(element, gistId, linkId) {
    let callbackName = "gist_callback_" + linkId;

    window[callbackName] = function(gistData) {
        delete window[callbackName];
        let html = '<link rel="stylesheet" href="' + escapeHtml(gistData.stylesheet) + '"></link>';
        html += gistData.div;
        element.innerHTML = html;
        script.parentNode.removeChild(script);
    };

    let script = document.createElement("script");
    script.setAttribute("src", "https://gist.github.com/" + gistId + ".json?callback=" + callbackName);
    document.body.appendChild(script);
}

$(document).on('turbolinks:load', function() {
    let $gists = $('.gist-content')

    $gists.each(function () {
        let $link = $(this)
        loadGist($link[0], $link.data('gist-id'), $link.data('link-id'))
    })
});
