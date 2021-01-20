// Функция показывет иконку выбранного ответа
$(document).on('turbolinks:load', function() {
    $('.answer').each(function() {
        let $icon = $(this).find('.accepted-answer-icon')
        let $link = $(this).find('.accept-answer-link')

        if ($(this).data('accepted') === true) {
            if ($link.length) { $link.hide() }
            $icon.show()

            $('.answers').prepend($(this))
        } else {
            if ($link.length) { $link.show() }
            $icon.hide()
        }
    })
});
