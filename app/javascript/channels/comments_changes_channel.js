import consumer from "./consumer"

consumer.subscriptions.create("CommentsChangesChannel", {
    received(data) {
        if (data.action === 'create') {
            $(data.selector).append(data.template)
        }
    }
});
