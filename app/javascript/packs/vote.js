$(document).on('turbolinks:load', function() {
    $('.vote-link').on('ajax:success', function(e) {
        let resource = e.detail[0];

        if (resource.status === "ok") { $(e.target).siblings('.current-rating').html(resource.rating) }
        if (resource.status === 'notAllowed' || resource.status === 'notAuthorized') { alert(resource.message); }
    })
});
