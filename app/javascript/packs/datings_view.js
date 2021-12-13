$(document).ready(() => {
    const profilesLink = $("#choose-profile");
    disableLink(profilesLink);

    profilesLink.click(() => {
        disableLink($("#choose-profile"));
        disableBlock($(".dialogs"));
        enableLink($("#choose-dialogs"));
        enableBlock($(".profile"));
    })

    $("#choose-dialogs").click(() => {
        enableLink($("#choose-profile"));
        enableBlock($(".dialogs"));
        disableLink($("#choose-dialogs"));
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

    $("#generate-user-btn").click(() => {
        $.ajax({
            method: "GET",
            url: "/admin/generate-user",
        });
    });

    loadNewProfile();

    loadDialogList();
    setInterval(() => loadDialogList(), 1000);
    setInterval(() => loadDialog(), 1000);
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

function loadNewProfile() {
    $.ajax({
        method: "GET",
        url: "/datings/random-profile",
        statusCode: {
            200: data => changeFoundProfile(JSON.parse(data))
        }
    });
}

function changeFoundProfile(user) {
    $(".profile-wrapper").empty();
    const profileDiv = $('<div>', {
        class: 'other-profile center-div'
    }).appendTo(".profile-wrapper");

    const imageName = user.has_pic ? user.id : "empty";
    $('<img>', {
        src: `/images/profiles/${imageName}.png`,
        alt: 'Image picture'
    }).appendTo(profileDiv);

    const nameWithAge = `${user.name}, ${user.age}`
    $('<h5>').text(nameWithAge).appendTo(profileDiv);
    $('<p>', { style: "white-space: pre-line" }).text(user.description).appendTo(profileDiv);
    $('<button>', { class: 'btn btn-success' }).text(I18n['dating']['like']).click(() => {
        saveProfileReaction(user, true);
    }).appendTo(profileDiv);

    $('<button>', { class: 'btn btn-danger' }).text(I18n['dating']['dislike']).click(() => {
        saveProfileReaction(user, false);
    }).appendTo(profileDiv);
}

function saveProfileReaction(user, isLike) {
    $.ajax({
        method: "GET",
        url: "/datings/save-reaction",
        data: {
            user_id: user.id,
            is_like: isLike
        }
    });
    loadNewProfile();
}

function loadDialogList() {
    $.ajax({
        method: "GET",
        url: "/datings/dialogs",
        statusCode: {
            200: data => updateDialogList(JSON.parse(data))
        }
    });
}

function updateDialogList(dialogs) {
    const container = $(".dialogs").empty();
    for (const dialog of dialogs) {
        const dialogDiv = $("<div>", {
            class: "dialog"
        }).click(() => {
            currentDialogID = dialog.id;
            loadDialog();
        }).appendTo(container);

        const imageWrapper = $("<div>", {
            style: "width: 30%; height: 100%"
        }).appendTo(dialogDiv);

        const imageName = dialog.has_pic ? dialog.user_id : "empty";
        $('<img>', {
            src: `/images/profiles/${imageName}.png`,
            alt: 'Image picture'
        }).appendTo(imageWrapper);

        const textWrapper = $("<div>", {
            style: "width: 70%; height: 100%"
        }).appendTo(dialogDiv);
        $('<h5>').text(dialog.name).appendTo(textWrapper);
        $('<p>').text(dialog.last_message).appendTo(textWrapper);
    }
}

let currentDialogID = -1;

function loadDialog() {
    if (currentDialogID < 0) return;

    $.ajax({
        method: "GET",
        url: "/datings/messages",
        data: {
            dialog: currentDialogID
        },
        statusCode: {
            200: data => updateDialog(JSON.parse(data))
        }
    });
}

let lastDialogID = -1;
function updateDialog(dialog) {
    const container = $(".dialog-wrapper");
    const dialogInput = $("#dialog-input");

    if (dialogInput.length === 0) {
        const form = $("<form>", {
            style: "width: 100%"
        }).submit(() => sendMessage()).appendTo(container);

        $("<input>", {
            type: "text",
            id: "dialog-input",
            style: "width: 100%"
        }).appendTo(form);
    } else if (currentDialogID !== lastDialogID) {
        dialogInput.val("");
        lastDialogID = currentDialogID;
    }

    let messagesWrapper = $(".messages").empty();
    if (messagesWrapper.length === 0) {
        messagesWrapper = $("<div>", {class: "messages"});
        messagesWrapper.appendTo(container);
    }

    for (const message of dialog.reverse()) {
        const messageDiv = $("<div>", {
            style: `
                margin-${message.is_own ? "left" : "right"}: auto;
                margin-${message.is_own ? "right" : "left"}: 1%;
                background-color: ${message.is_own ? "lightblue" : "lightyellow"};
                max-width: 70%;
                margin-top: 2%;
                border-radius: 5px;
            `
        }).appendTo(messagesWrapper);
        $("<p>").text(message.text).appendTo(messageDiv);
    }
}

function sendMessage() {
    const inputElement = $("#dialog-input");
    const text = inputElement.val();
    if (text.length === 0) return false;

    inputElement.val('');

    $.ajax({
        method: "GET",
        url: "/datings/send-message",
        data: {
            dialog: currentDialogID,
            text: text,
        },
        statusCode: {
            200: () => {
                loadDialogList();
                loadDialog();
            }
        }
    });

    return false;
}