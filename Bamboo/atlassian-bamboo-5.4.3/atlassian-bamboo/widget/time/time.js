(function (BAMBOO, moment) {
    BAMBOO.Time = {};

    var hasOwn = Object.prototype.hasOwnProperty,
        dateFormatCache = {},
        dateTokenizer = /d{1,2}|'[^']+'|M{1,4}|y{2,4}|h{1,2}|H{1,2}|m{2}|s{2}|S{1,4}|Z{1,2}|z{1,2}|a|:|-|\/|\s+/g;

    function Type(str, isAge) {
        if (this instanceof Type) {
            this.key = str;
            this.isAge = isAge;
            return this;
        } else {
            return str && hasOwn.call(Type, str) ? Type[str] : null;
        }
    }

    for (var a = ['shortAge', 'longAge', 'short', 'long', 'full', 'timestamp'], i = 0, l = a.length, t; i < l; i++) {
        t = a[i];
        Type[t] = new Type(t, t.toLowerCase().indexOf('age') !== -1);
    }

    function getTextForRelativeAge(age, type, param) {
        switch(age) {
            case 'aMomentAgo':
                return type === Type.shortAge ?
                       AJS.I18n.getText('bamboo.date.format.short.a.moment.ago') :
                       AJS.I18n.getText('bamboo.date.format.long.a.moment.ago');
            case 'oneMinuteAgo':
                return type === Type.shortAge ?
                       AJS.I18n.getText('bamboo.date.format.short.one.minute.ago') :
                       AJS.I18n.getText('bamboo.date.format.long.one.minute.ago');
            case 'xMinutesAgo':
                return type === Type.shortAge ?
                       AJS.I18n.getText('bamboo.date.format.short.x.minutes.ago', param) :
                       AJS.I18n.getText('bamboo.date.format.long.x.minutes.ago', param);
            case 'oneHourAgo':
                return type === Type.shortAge ?
                       AJS.I18n.getText('bamboo.date.format.short.one.hour.ago') :
                       AJS.I18n.getText('bamboo.date.format.long.one.hour.ago');
            case 'xHoursAgo':
                return type === Type.shortAge ?
                       AJS.I18n.getText('bamboo.date.format.short.x.hours.ago', param) :
                       AJS.I18n.getText('bamboo.date.format.long.x.hours.ago', param);
            case 'oneDayAgo':
                return type === Type.shortAge ?
                       AJS.I18n.getText('bamboo.date.format.short.one.day.ago') :
                       AJS.I18n.getText('bamboo.date.format.long.one.day.ago');
            case 'xDaysAgo':
                return type === Type.shortAge ?
                       AJS.I18n.getText('bamboo.date.format.short.x.days.ago', param) :
                       AJS.I18n.getText('bamboo.date.format.long.x.days.ago', param);
            case 'oneWeekAgo':
                return type === Type.shortAge ?
                       AJS.I18n.getText('bamboo.date.format.short.one.week.ago') :
                       AJS.I18n.getText('bamboo.date.format.long.one.week.ago');
            default:
                return null;
        }
    }

    function toMomentFormat(javaDateFormat) {
        if (hasOwn.call(dateFormatCache, javaDateFormat)) {
            return dateFormatCache[javaDateFormat];
        }
        var momentDateFormat = "", token;
        dateTokenizer.exec('');
        while (token = dateTokenizer.exec(javaDateFormat)) {
            token = token[0];
            switch(token.charAt(0)) {
                case "'":
                    momentDateFormat += '[' + token.substring(1, token.length-1) + ']';
                    break;
                case 'd':
                case 'y':
                case 'a':
                    momentDateFormat += token.toUpperCase();
                    break;
                default:
                    momentDateFormat += token;
            }
        }
        dateFormatCache[javaDateFormat] = momentDateFormat;
        return momentDateFormat;
    }
    
    function getFormatString(type) {
        switch (type.key) {
            case 'short':
            case 'shortAge':
                return AJS.I18n.getText('bamboo.date.format.short');
            case 'long':
            case 'longAge':
                return AJS.I18n.getText('bamboo.date.format.long');
            case 'full':
                return AJS.I18n.getText('bamboo.date.format.full');
            case 'timestamp':
                return AJS.I18n.getText('bamboo.date.format.timestamp');
            default:
                return null;
        }
    }

    function isYesterday(now, date) {
        var end = now.clone().add('d', 1).hours(0).minutes(0).seconds(0).milliseconds(0);
        while (end > now) {
            end.subtract('d', 1);
        }
        var start = end.clone().subtract('d', 1);
        return start <= date && date < end;
    }

    function getSecondsBetween(start, end) {
        return Math.floor(end.diff(start, 'seconds', true));
    }

    function getMinutesBetween(start, end) {
        return Math.floor(end.diff(start, 'minutes', true));
    }

    function getHoursBetween(start, end) {
        return end.diff(start, 'hours'); // diff rounds by default
    }

    function getDaysBetween(start, end) {
        return Math.floor(end.diff(start, 'days', true));
    }

    function getMonthsBetween(start, end) {
        return end.diff(start, 'months', true);
    }

    function formatDateWithFormatString(date, type) {
        var formatString = toMomentFormat(getFormatString(type));

        return date.format(formatString);
    }

    function formatDateWithRelativeAge(date, type, now) {
        now = now || moment();

        if (date <= now) {
            if (date > now.clone().subtract('m', 1)) {
                return getTextForRelativeAge('aMomentAgo', type);
            } else if (date > now.clone().subtract('m', 2)) {
                return getTextForRelativeAge('oneMinuteAgo', type);
            } else if (date > now.clone().subtract('m', 50)) {
                return getTextForRelativeAge('xMinutesAgo', type, getMinutesBetween(date, now));
            } else if (date > now.clone().subtract('m', 90)) {
                return getTextForRelativeAge('oneHourAgo', type);
            } else if (isYesterday(now, date) && date < now.clone().subtract('h', 5)) {
                return getTextForRelativeAge('oneDayAgo', type);
            } else if (date > now.clone().subtract('d', 1)) {
                return getTextForRelativeAge('xHoursAgo', type, getHoursBetween(date, now));
            } else if (date > now.clone().subtract('d', 7)) {
                return getTextForRelativeAge('xDaysAgo', type, Math.max(getDaysBetween(date, now), 2));// if it's not yesterday then don't say it's one day ago
            } else if (date > now.clone().subtract('d', 8)) {
                return getTextForRelativeAge('oneWeekAgo', type);
            }
        }
        return formatDateWithFormatString(date, type);
    }

    function formatDate(momentDate, type) {
        if (momentDate && type) {
            if (type.isAge) {
                return formatDateWithRelativeAge(momentDate, type);
            } else {
                return formatDateWithFormatString(momentDate, type);
            }
        } else {
            return null;
        }
    }

    /*
     * Currently only supports the default 'long' formatting.
     */
    function elapsedTime(dateFrom, dateTo) {
         dateTo = dateTo || moment();
         if (dateFrom && dateFrom <= dateTo) {
             var months = getMonthsBetween(dateFrom, dateTo);
             if (months < 1) {
                 var minutes = getMinutesBetween(dateFrom, dateTo);
                 if (minutes < 1) {
                     var seconds = getSecondsBetween(dateFrom, dateTo);
                     if (seconds < 1) {
                         return AJS.I18n.getText('bamboo.date.format.duration.long.a.moment.ago');
                     } else if (seconds > 1) {
                         return AJS.I18n.getText('bamboo.date.format.duration.long.x.seconds', seconds);
                     } else {
                         return AJS.I18n.getText('bamboo.date.format.duration.long.one.second');
                     }
                 } else if (minutes > 1) {
                     return AJS.I18n.getText('bamboo.date.format.duration.long.x.minutes', minutes);
                 } else {
                     return AJS.I18n.getText('bamboo.date.format.duration.long.one.minute');
                 }
             } else {
                 return AJS.I18n.getText('bamboo.date.format.duration.long.toolong');
             }
        }
        return null;
    }

    BAMBOO.Time.format = function (dateOrNumberOrString, typeString) {
        return formatDate(dateOrNumberOrString ? moment(dateOrNumberOrString) : null, Type(typeString));
    }

    BAMBOO.Time.elapsedTime = function (dateOrNumberOrStringFrom, dateOrNumberOrStringTo) {
        var dateFrom = dateOrNumberOrStringFrom ? moment(dateOrNumberOrStringFrom) : null;
        var dateTo = dateOrNumberOrStringTo ? moment(dateOrNumberOrStringTo) : null;
        return elapsedTime(dateFrom, dateTo);
    }

}(window.BAMBOO = (window.BAMBOO || {}), moment));