$(document).ready(() => {
    $("#change-lang").click(() => {
        $("#lang-container").css("display", "block");
    });

    $("a[data-locale]").click((event) => {
        const locale = $(event.target).data("locale");
        $.cookie("locale", locale);
        document.location.reload();
    });

    $(".close-btn").click(() => {
        $(".fullscreen-container").css("display", "none");
    });
});