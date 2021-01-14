// Функция подготовки формы редактирования вопроса
$(document).on('turbolinks:load', function() {
    let $edit_link = $('#edit-question-link')

    if ($edit_link.length) {
        $edit_link.off()
        $edit_link.on('click', function(event) {
            event.preventDefault()

            let $edit_window = $('#edit-question-form-modal')
            let $edit_form   = $edit_window.find('form')

            let currentQuestionTitleText = $('#question-title').text()
            let currentQuestionBodyText  = $('#question-body').text()

            // Изменяем url формы
            $edit_form.attr('action', '/questions/' + $(this).data('questionId'))
            // Добавляем текущий текст ответа в форму
            $('#edit-question-title-input').val(currentQuestionTitleText)
            $('#edit-question-body-input').val(currentQuestionBodyText)
            $('#question_files').val(null)
            // Показываем окно
            $edit_window.modal('show')
        })
    }
});

// Функция прячет кнопку сабмита формы редактирования вопроса
$(document).on('turbolinks:load', function() {
    let $edit_window = $('#edit-question-form-modal')

    if ($edit_window.length) {
        let $edit_form = $edit_window.find('form')

        if ($edit_form.length) {
            let $title_input = $('#edit-question-title-input')
            let $body_input  = $('#edit-question-body-input')
            let $submit_btn  = $('#edit-question-form-btn')

            $title_input.off()
            $body_input.off()
            $title_input.on('input', function() { change_btn_state() });
            $body_input.on('input', function() { change_btn_state() });

            function change_btn_state() {
                if ($title_input.val().length < 5 || $body_input.val().length < 5 ) {
                    $submit_btn.hide()
                } else {
                    $submit_btn.show()
                }
            }
        }
    }
});
