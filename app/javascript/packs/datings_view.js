$(document).ready(() => {
    $("#choose-profile").click(() => {
        disableLink($("#choose-profile"));
        disableBlock($(".chats"));
        enableLink($("#choose-chats"));
        enableBlock($(".profile"));
    })

    $("#choose-chats").click(() => {
        enableLink($("#choose-profile"));
        enableBlock($(".chats"));
        disableLink($("#choose-chats"));
        disableBlock($(".profile"));
    })

    const loginForm = $("#update-profile-form");
    loginForm.submit(() => {
        const domElement = document.getElementById("update-profile-form");
        $.ajax({
            method: "POST",
            url: "/datings/update",
            data: new FormData(domElement),
            processData: false,
            contentType: false,
            statusCode: {
                200: () => {
                    document.location.reload();
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

function disableLink(link) {
    link.css("color", "black").css("pointer-events", "none");
}

function enableLink(link) {
    link.css("color", "").css("pointer-events", "");
}

function disableBlock(block) {
    block.css("display", "none");
}

function enableBlock(block) {
    block.css("display", "block");
}