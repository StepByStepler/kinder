window.iziToast = function iziToast() {
    return require('izitoast')
}

$(document).ready(() => {
    $("#login").click(() => {
        $("#login-container").css("display", "block");
    });

    $(".a-register").click(() => {
        $("#login-container").css("display", "none");
        $("#register-container").css("display", "block");
    })

    $(".close-btn").click(() => {
        $(".fullscreen-container").css("display", "none");
    })

    $("#change-lang").click(() => {
        $("#lang-container").css("display", "block");
    })

    $(".fullscreen-container").mousedown((e) => {
        if (e.target.classList.contains('fullscreen-container')) {
            $(".fullscreen-container").css("display", "none");
        }
    })

    const loginForm = $("#login-form");
    loginForm.submit(() => {
        $.ajax({
            method: "GET",
            url: "/sessions/login",
            data: loginForm.serialize(),
            statusCode: {
                200: () => {
                    document.location.href = '/datings/view';
                },
                401: (data) => {
                    iziToast().error({
                        title: data.responseText
                    });
                }
            }
        });
        return false;
    });

    $("a[data-locale]").click((event) => {
        const locale = $(event.target).data("locale");
        $.cookie("locale", locale);
        document.location.reload();
    });

    const registerForm = $("#register-form");
    registerForm.submit(() => {
        $.ajax({
            method: "GET",
            url: "/sessions/register",
            data: registerForm.serialize(),
            statusCode: {
                200: (data) => {
                    $("#register-container").css("display", "none");
                    iziToast().info({
                        title: data
                    });
                },
                401: (data) => {
                    iziToast().error({
                        title: data.responseText
                    });
                }
            }
        });
        return false;
    });


});
