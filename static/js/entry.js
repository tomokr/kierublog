/**
 * XHR でサーバーからブックマークの情報を取得してブックマーク一覧を更新。
 */
var nowpage, per_page;

function updateContent(page, per_page) {

    nowpage = page;
    per_page = per_page;

    var contentElem = document.getElementById("content");
    contentElem.innerHTML = "";

    function createEntryItemElem(e) {

        var itemElem = document.createElement("div");
        itemElem.className = "entry";
        // タイトル
        var titleElem = itemElem.appendChild(document.createElement("h3"));
        titleElem.textContent = e.title;

        //日付
        var dateElem = itemElem.appendChild(document.createElement("div"));
        dateElem.className = "date";
        dateElem.textContent = e.date;

        // 本文
        var textElem = itemElem.appendChild(document.createElement("div"));
        textElem.innerHTML = (e.text).replace(/\r\n/g,"<br>");

        var brElem = itemElem.appendChild(document.createElement("br"));

         var linkElem = itemElem.appendChild(document.createElement("a"));
         linkElem.href = "./entry?id="+e.id;
         linkElem.innerHTML = "この記事を編集/削除する";

        return itemElem;
    }

    function showProgress() {
        contentElem.innerHTML = "<div class=\"message\">ブックマーク一覧を読み込んでいます。</div>"
    }

    function showError() {
        contentElem.innerHTML = "<div class=\"message\">ブックマーク一覧を読み込めませんでした。</div>"
    }

 //   記事ページを動かすためのボタン
　　　function createLinks(number_of_entry){
        var linksDivElem = document.createElement("div");
        var prevLinksElem = linksDivElem.appendChild(document.createElement("a"));

        if(nowpage>1){
        prevLinksElem.href = "javascript:void(0);";
        prevLinksElem.onclick = function () {updateContent((nowpage-1),per_page)};
        prevLinksElem.innerHTML = "<前へ";
        }

        if(number_of_entry>2){ //いまは1ページの記事数3なので
        var nextLinksElem = linksDivElem.appendChild(document.createElement("a"));
        nextLinksElem.href = "javascript:void(0);";
        nextLinksElem.onclick = function () {updateContent((nowpage+1),per_page)};
        nextLinksElem.innerHTML = "次へ>";
    }


        return linksDivElem;
 　　　}

    var xhr = new XMLHttpRequest();
    xhr.open("GET", "/api/entries?page="+page+"&per_page="+per_page, true);
    xhr.addEventListener("load", function (evt) {
        contentElem.innerHTML = "";
        var xhr = evt.currentTarget;
        if (xhr.status === 200) {
            var entriesInfo = JSON.parse(xhr.responseText);
            var number_of_entry = 0;
            entriesInfo.entries.forEach(function (e) {
                contentElem.appendChild(createEntryItemElem(e));
                number_of_entry++;
            }
            );
            console.log(number_of_entry);
            contentElem.appendChild(createLinks(number_of_entry));
        } else {
            showError();
        }
    }, false);
    xhr.send();
    showProgress();

}//updateContentおわり


// ページ読み込み時の初期化処理
//初期設定ではページ1、ページごとの記事数3
document.addEventListener("DOMContentLoaded", function (evt) {
    updateContent(1,3);
}, false);