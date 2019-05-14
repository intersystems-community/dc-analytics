function beforeWeekDates(UTCtimezone) {
    var mS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];    
    var date = new Date();
    var c_date = new Date((date.getTime() + (date.getTimezoneOffset() * 60000)) + (3600000 * UTCtimezone));
    var bmon_date = new Date(c_date);
    bmon_date.setDate(bmon_date.getDate() - 7 - (bmon_date.getDay() == 0 ? 6 : bmon_date.getDay() - 1));
    var bsun_date = new Date(c_date);
    bsun_date.setDate(bsun_date.getDate() - 7 + (bsun_date.getDay() == 0 ? 0 : 7 - bsun_date.getDay()));

    var bmon_format = ('0' + bmon_date.getDate()).slice(-2) + ' ' + mS[bmon_date.getMonth()] + ' ' + bmon_date.getFullYear();
    var bsun_format = ('0' + bsun_date.getDate()).slice(-2) + ' ' + mS[bsun_date.getMonth()] + ' ' + bsun_date.getFullYear();

    return bmon_format + " - " + bsun_format
}

/**
 * Общие настройки отчёта
 * @param params Параметы отправляемые в функцию обработки блоков.
 *               по умолчанию содержит параметр server.
 * @returns {{REPORT_NAME: string, BLOCKS: *[], NAMESPACE: string}}
 */
function getConfiguration(params) {
    if (params.ns == undefined || params.ns == null) params.ns = "DCANALYTICS";
    if (params.filter == undefined || params.filter == null) params.filter = "NOW-1";
    if (params.date_string == undefined || params.date_string == null) params.date_string = beforeWeekDates(-5);
    return {
        REPORT_NAME: "Developer Community Weekly Report<br />Period: " + params.date_string, // Заголовок отчёта
        BLOCKS: getReportBlocks(params),
        NAMESPACE: params.ns // Значение области для отчёта
    };
}

/**
 * Функция получения настроек блоков с виджетами.
 * @param params Параметы.
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
    var namespace = params.ns;
    var filter = params.filter;
    return [
        {
            title: "Posts by Members",
            note: "",
            widget: {
                url: server + "/dsw/index.html#!/d/Week/WeekView.dashboard?FILTERS=TARGET:*;FILTER:%5BDateDimension%5D.%5BH1%5D.%5BWeekYear%5D.%26%5B"+filter+"%5D&widget=0&height=450&showValues=true&ns=" + namespace,
                width: 1000,
                height: 450
            }
        },
        {
        title: "Posts Daily",
        note: "",
        widget: {
            url: server + "/dsw/index.html#!/d/Week/WeekView.dashboard?FILTERS=TARGET:*;FILTER:%5BDateDimension%5D.%5BH1%5D.%5BWeekYear%5D.%26%5B"+filter+"%5D&widget=1&height=300&isLegend=true" + namespace,
            width: 800,
            height: 350
        },
        totals: [{
            mdx: "SELECT NON EMPTY {AVG([DateDimension].[H1].[WeekYear].Members),[DateDimension].[H1].[WeekYear].&["+filter+"],%LABEL(%CELL(0,-1)-%CELL(0,-2),\"Performance\",\"\")} ON 1 FROM [POST]",
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
        url: server + "/dsw/index.html#!/d/Week/WeekView.dashboard?FILTERS=TARGET:*;FILTER:%5BDateDimension%5D.%5BH1%5D.%5BWeekYear%5D.%26%5B"+filter+"%5D&widget=2&height=450&showValues=true&ns=" + namespace,
        width: 1000,
        height: 750
    }
}, {
    title: "Comments Daily",
    note: "",
    widget: {
        url: server + "/dsw/index.html#!/d/Week/WeekView.dashboard?FILTERS=TARGET:*;FILTER:%5BDateDimension%5D.%5BH1%5D.%5BWeekYear%5D.%26%5B"+filter+"%5D&widget=3&height=300&isLegend=true" + namespace,
        width: 800,
        height: 350
    },
    totals: [{
        mdx: "SELECT NON EMPTY {AVG([DateDimension].[H1].[WeekYear].Members),[DateDimension].[H1].[WeekYear].&["+filter+"],%LABEL(%CELL(0,-1)-%CELL(0,-2),\"Performance\",\"\")} ON 1 FROM [COMMENT]",
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
    url: server + "/dsw/index.html#!/d/Week/WeekView.dashboard?FILTERS=TARGET:*;FILTER:%5BDateDimension%5D.%5BH1%5D.%5BWeekYear%5D.%26%5B"+filter+"%5D&widget=4&height=400&ns=" + namespace,
    width: 1000,
    height: 400
        }
}, {
    title: "Comments by Groups",
    note: "",
    widget: {
    url: server + "/dsw/index.html#!/d/Week/WeekView.dashboard?FILTERS=TARGET:*;FILTER:%5BDateDimension%5D.%5BH1%5D.%5BWeekYear%5D.%26%5B"+filter+"%5D&widget=5&height=400&ns=" + namespace,
    width: 1000,
    height: 800
        }
}, {
    title: "Articles and Announcements of the week",
    note: "",
    widget: {
        url: server + "/dsw/index.html#!/d/Week/DigestLists.dashboard?widget=0&height=500&isLegend=false" + namespace,
        width: 800,
        height: 500
    },
    totals: [{
        mdx: "SELECT NON EMPTY {[DateDimension].[H1].[WeekYear].&[NOW-1],"+
            "%LABEL(AVG([DateDimension].[H1].[WeekYear].Members),\"\",\"#\"),"+
            "%LABEL(%CELL(0,-2)-%CELL(0,-1),\"\",\"#\")} ON 1 FROM [POST] "+
            "%FILTER [POSTTYPE].[H1].[POSTTYPE].&[Article]",
        strings: [{
            title: "Articles this week: ",
            value: "None",
            row: 0
        }, {
            title: "Articles average: ",
            value: "None",
            row: 1
        }, {
            title: "Performance:",
            value: "None",
            row: 2
        }]
    },{
        mdx: "SELECT NON EMPTY {[DateDimension].[H1].[WeekYear].&[NOW-1],"+
            "%LABEL(AVG([DateDimension].[H1].[WeekYear].Members),\"\",\"#\"),"+
            "%LABEL(%CELL(0,-2)-%CELL(0,-1),\"\",\"#\")} ON 1 FROM [POST] "+
            "%FILTER [POSTTYPE].[H1].[POSTTYPE].&[Announcement]",
        strings: [{
            title: "Announcements this week: ",
            value: "None",
            row: 0
        }, {
            title: "Announcements average: ",
            value: "None",
            row: 1
        }, {
            title: "Performance:",
            value: "None",
            row: 2
        }]
    }]
}, {
    title: "Questions of the week",
    note: "",
    widget: {
        url: server + "/dsw/index.html#!/d/Week/DigestLists.dashboard?widget=1&height=1000&isLegend=false" + namespace,
        width: 800,
        height: 1000
    },
    totals: [{
        mdx: "SELECT NON EMPTY {[DateDimension].[H1].[WeekYear].&[NOW-1],"+
            "%LABEL(AVG([DateDimension].[H1].[WeekYear].Members),\"\",\"#\"),"+
            "%LABEL(%CELL(0,-2)-%CELL(0,-1),\"\",\"#\")} ON 1 FROM [POST] "+
            "%FILTER [POSTTYPE].[H1].[POSTTYPE].&[Question]",
        strings: [{
            title: "Questions this week: ",
            value: "None",
            row: 0
        }, {
            title: "Questions average: ",
            value: "None",
            row: 1
        }, {
            title: "Performance:",
            value: "None",
            row: 2
        }]
    }]
}

];
}