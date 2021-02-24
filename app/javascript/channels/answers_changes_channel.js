import consumer from "./consumer"

consumer.subscriptions.create("AnswersChangesChannel", {
    received(data) {
        if (data.action === 'create') {
            $('.answers').append(data.template)
            $(document).trigger('turbolinks:load')
        }
    }
});
