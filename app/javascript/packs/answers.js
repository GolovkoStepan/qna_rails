// Функция прячет кнопку создания ответа, пока не будет введено нужное кол-во символов
$(document).on('turbolinks:load', function() {
    let $input = $('#create_answer_input')
    let $btn   = $('#create_answer_btn')

    if ($input.length && $btn.length) {
        change_btn_state()
        $input.off()
        $input.on('input', function() { change_btn_state() });
    }

    function change_btn_state() {
        if ($input.val().length < 5) { $btn.hide() } else { $btn.show() }
    }
});

// Функция отправляет запрос на удаление ответа и в зависимости от ответа сервера удаляет/не удаляет html
$(document).on('turbolinks:load', function() {
    let $delete_answer_links = $('.delete-answer-link')

    if ($delete_answer_links.length) {
        $delete_answer_links.off()
        $delete_answer_links.on('click', function(event) {
            event.preventDefault()
            let answerId = $(this).data('answerId')

            $.ajax({
                url: '/answers/' + answerId,
                dataType: 'json',
                type: 'DELETE',
                statusCode: {
                    200: function(_) {
                        $('#answer-' + answerId).remove()
                        $('#answers-count').html(Number($('#answers-count').text()) - 1)
                    },
                    403: function(_) {
                        $(this).hide() // WTF?? скрываем линк от греха подальше
                        console.log("Forbidden error. The user cannot delete someone else's answer.")
                    }
                }
            })
        })
    }
});

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

// Функция подготовки формы редактирования ответа
$(document).on('turbolinks:load', function() {
    let $edit_links = $('.answer .edit-answer-link')

    if ($edit_links.length) {
        $edit_links.off()
        $edit_links.on('click', function(event) {
            event.preventDefault()

            let $edit_window = $('#edit-answer-form-modal')
            let $edit_form   = $edit_window.find('form')

            let $current_answer   = $('#answer-' + $(this).data('answerId'))
            let currentAnswerText = $current_answer.find('.card .card-body').text()

            // Изменяем url формы
            $edit_form.attr('action', '/answers/' + $(this).data('answerId'))
            // Добавляем текущий текст ответа в форму
            $('#edit-answer-form-input').val(currentAnswerText)
            $('#answer_files').val(null)
            // Показываем окно
            $edit_window.modal('show')
        })
    }
});

// Функция прячет кнопку сабмита формы редактирования вопроса
$(document).on('turbolinks:load', function() {
    let $edit_window = $('#edit-answer-form-modal')

    if ($edit_window.length) {
        let $edit_form = $edit_window.find('form')

        if ($edit_form.length) {
            let $body_input  = $('#edit-answer-form-input')
            let $submit_btn  = $('#edit-answer-form-btn')

            $body_input.off()
            $body_input.on('input', function() { change_btn_state() });

            function change_btn_state() {
                if ($body_input.val().length < 5 ) { $submit_btn.hide() } else { $submit_btn.show() }
            }
        }
    }
});
