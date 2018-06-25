/**
 * Общие настройки отчёта
 * @param params Параметы отправляемые в функцию обработки блоков.
 * @returns {{REPORT_NAME: string, BLOCKS: *[], NAMESPACE: string}}
 */
function getConfiguration(params) {
    if (params.namespace == undefined || params.namespace == null) params.namespace = "DSWREP";
    return {
        REPORT_NAME: "Report Example", // Заголовок отчёта
        BLOCKS: getReportBlocks(params),
        NAMESPACE: params.namespace // Значение области для отчёта
    }
}

/**
 * Функция получения настроек блоков с виджетами.
 * @param params Параметы. По умолчанию содержит сервер и область.
 * @returns {*[]}
 */
function getReportBlocks(params) {
    /**
     * block={
     *  title: String,                  // Заголовок блока
     *  note: String,                   // Замечания под блоком. Могут содержать HTML код
     *  widget: {                       // Настройки iframe виджета:
     *      url: String,                //  URL источника для iframe
     *      height: Number,             //  Высота iframe
     *      width: Number               //  Ширина iframe
     *  },
     *  totals:[{                       // Настройки значений вычисляемых с помощью MDX (значений может быть несколько):
     *      mdx: String                 //  MDX запрос
     *      strings: [{                 //  Строки значений из запроса (строк может быть несколько):
     *          title: String,          //      Заголовок строки. Может использовать HTML.
     *          value: String,          //      Значение строки по умолчанию
     *          value_append: String,   //      Суффикс для значения. Может использоваться для знаков %, $ и т.д.
     *                                  //          % преобразует значение в процентное. Может использовать HTML.
     *          row: Number             //      Номер строки MDX запроса, из которой берётся значение. По умолчанию 0.
     *      },{...}]
     *  },{...}]}
     *
     * Все поля обязательны. Если какое то поле вам не нужно оставьте пустую строку.
     */

    var server = params.server;
    var namespace = params.namespace;
    return [
        {
            title: "Posts by Members",
            note: "",
            widget: {
                url: server + "/dsw/index.html#!/d/Week/WeekView.dashboard?FILTERS=TARGET:*;FILTER:%5BDateDimension%5D.%5BH1%5D.%5BWeekYear%5D.%26%5B2018W10%5D&widget=0&height=500&ns=" + namespace,
                width: 700,
                height: 500
            }
        },
        {
        title: "Weekly Posts",
        note: "",
        widget: {
            url: server + "/dsw/index.html#!/d/Week/WeekView.dashboard?FILTERS=TARGET:*;FILTER:%5BDateDimension%5D.%5BH1%5D.%5BWeekYear%5D.%26%5B2018W10%5D&widget=1&height=300&isLegend=true" + namespace,
            width: 500,
            height: 350
        },
        totals: [{
            mdx: "SELECT NON EMPTY {AVG([DateDimension].[H1].[WeekYear].Members),[DateDimension].[H1].[WeekYear].&[2018W10],%LABEL(%CELL(0,-1)-%CELL(0,-2),\"Performance\",\"\")} ON 1 FROM [POST]",
            strings: [{
                title: "Posts this week: ",
                value: "None",
                row: 1
            }, {
                title: "Posts average: ",
                value: "None",
                row: 0
            }, {
                title: "Performance:",
                value: "None",
                row: 2
            }]
        }]
    }, {
        title: "Comments by Members",
        note: "",
        widget: {
        url: server + "/dsw/index.html#!/d/Week/WeekView.dashboard?FILTERS=TARGET:*;FILTER:%5BDateDimension%5D.%5BH1%5D.%5BWeekYear%5D.%26%5B2018W10%5D&widget=2&height=500&ns=" + namespace,
        width: 700,
        height: 500
            }
    }, 
     {

    title: "Weekly Comments",
    note: "",
    widget: {
        url: server + "/dsw/index.html#!/d/Week/WeekView.dashboard?FILTERS=TARGET:*;FILTER:%5BDateDimension%5D.%5BH1%5D.%5BWeekYear%5D.%26%5B2018W10%5D&widget=3&height=400&isLegend=true" + namespace,
        width: 500,
        height: 400
    },
    totals: [{
        mdx: "SELECT NON EMPTY {AVG([DateDimension].[H1].[WeekYear].Members),[DateDimension].[H1].[WeekYear].&[2018W10],%LABEL(%CELL(0,-1)-%CELL(0,-2),\"Performance\",\"\")} ON 1 FROM [COMMENT]",
        strings: [{
            title: "Comments this week: ",
            value: "None",
            row: 1
        }, {
            title: "Comments average: ",
            value: "None",
            row: 0
        }, {
            title: "Performance:",
            value: "None",
            row: 2
        }]
    }]
}, {
    title: "Posts by Groups",
    note: "",
    widget: {
    url: server + "/dsw/index.html#!/d/Week/WeekView.dashboard?FILTERS=TARGET:*;FILTER:%5BDateDimension%5D.%5BH1%5D.%5BWeekYear%5D.%26%5B2018W10%5D&widget=4&height=400&ns=" + namespace,
    width: 700,
    height: 450
        }
}, {
    title: "Comments by Groups",
    note: "",
    widget: {
    url: server + "/dsw/index.html#!/d/Week/WeekView.dashboard?FILTERS=TARGET:*;FILTER:%5BDateDimension%5D.%5BH1%5D.%5BWeekYear%5D.%26%5B2018W10%5D&widget=5&height=400&ns=" + namespace,
    width: 700,
    height: 450
        }
}

];
}