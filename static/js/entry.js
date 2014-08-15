function updateContent() {

    var contentElem = document.getElementById("content");
    contentElem.innerHTML = "";

    function createBookmarkItemElem(e) {
        var itemElem = document.createElement("div");
        itemElem.className = "bookmar";
        // ページタイトル
        var entryElem = itemElem.appendChild(document.createElement("div"));
        var anchorElem = entryElem.appendChild(document.createElement("a"));
        anchorElem.textContent = e.entry.title || e.entry.url;
        anchorElem.href = e.entry.url;
        // コメント
        itemElem.appendChild(document.createElement("span")).textContent = e.comment;
        return itemElem;
    }

var xhr = new XMLHttpRequest();
    xhr.open("GET", "/api/entries", true);
    xhr.addEventListener("load", function (evt) {
        contentElem.innerHTML = "";
        var xhr = evt.currentTarget;
        if (xhr.status === 200) {
            var bookmarksInfo = JSON.parse(xhr.responseText);
            bookmarksInfo.bookmarks.forEach(function (e) {
                contentElem.appendChild(createBookmarkItemElem(e));
            });
        } else {
            showError();
        }
    }, false);
    xhr.send();

}