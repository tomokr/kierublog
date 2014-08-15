/**
 * XHR でサーバーからブックマークの情報を取得してブックマーク一覧を更新。
 */
function updateContent() {

    var contentElem = document.getElementById("content");
    contentElem.innerHTML = "";

    function createEntryItemElem(e) {
        var itemElem = document.createElement("div");
        itemElem.className = "entry";
        // タイトル
        var titleElem = itemElem.appendChild(document.createElement("h3"));
        titleElem.textContent = e.title;
        // 本文
        var textElem = itemElem.appendChild(document.createElement("div"));
        textElem.innerHTML = (e.text).replace(/\r\n/g,"<br>");

        return itemElem;
    }

    function showProgress() {
        contentElem.innerHTML = "<div class=\"message\">ブックマーク一覧を読み込んでいます。</div>"
    }

    function showError() {
        contentElem.innerHTML = "<div class=\"message\">ブックマーク一覧を読み込めませんでした。</div>"
    }

    var xhr = new XMLHttpRequest();
    xhr.open("GET", "/api/entries", true);
    xhr.addEventListener("load", function (evt) {
        contentElem.innerHTML = "";
        var xhr = evt.currentTarget;
        if (xhr.status === 200) {
            var entriesInfo = JSON.parse(xhr.responseText);
            entriesInfo.entries.forEach(function (e) {
                contentElem.appendChild(createEntryItemElem(e));
            });
        } else {
            showError();
        }
    }, false);
    xhr.send();
    showProgress();

}

// ページ読み込み時の初期化処理
document.addEventListener("DOMContentLoaded", function (evt) {
    updateContent();
}, false);