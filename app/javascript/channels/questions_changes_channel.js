import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChangesChannel", {
    received(data) {
        if (data.action === 'create') {
            $('#questions-block').append(data.template)
        }
    }
});
