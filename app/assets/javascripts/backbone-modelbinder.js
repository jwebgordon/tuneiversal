// Backbone.ModelBinder v1.0.5
// (c) 2013 Bart Wood
// Distributed Under MIT License

(function(e) {
    if (typeof define === "function" && define.amd) {
        define(["underscore", "jquery", "backbone"], e)
    } else {
        e(_, jQuery, Backbone)
    }
})(function(e, t, n) {
    if (!n) {
        throw "Please include Backbone.js before Backbone.ModelBinder.js"
    }
    n.ModelBinder = function() {
        e.bindAll.apply(e, [this].concat(e.functions(this)))
    };
    n.ModelBinder.SetOptions = function(e) {
        n.ModelBinder.options = e
    };
    n.ModelBinder.VERSION = "1.0.5";
    n.ModelBinder.Constants = {};
    n.ModelBinder.Constants.ModelToView = "ModelToView";
    n.ModelBinder.Constants.ViewToModel = "ViewToModel";
    e.extend(n.ModelBinder.prototype, {
        bind: function(e, n, r, i) {
            this.unbind();
            this._model = e;
            this._rootEl = n;
            this._setOptions(i);
            if (!this._model) this._throwException("model must be specified");
            if (!this._rootEl) this._throwException("rootEl must be specified");
            if (r) {
                this._attributeBindings = t.extend(true, {}, r);
                this._initializeAttributeBindings();
                this._initializeElBindings()
            } else {
                this._initializeDefaultBindings()
            }
            this._bindModelToView();
            this._bindViewToModel()
        },
        bindCustomTriggers: function(e, t, n, r, i) {
            this._triggers = n;
            this.bind(e, t, r, i)
        },
        unbind: function() {
            this._unbindModelToView();
            this._unbindViewToModel();
            if (this._attributeBindings) {
                delete this._attributeBindings;
                this._attributeBindings = undefined
            }
        },
        _setOptions: function(t) {
            this._options = e.extend({
                boundAttribute: "name"
            }, n.ModelBinder.options, t);
            if (!this._options["modelSetOptions"]) {
                this._options["modelSetOptions"] = {}
            }
            this._options["modelSetOptions"].changeSource = "ModelBinder";
            if (!this._options["changeTriggers"]) {
                this._options["changeTriggers"] = {
                    "": "change",
                    "[contenteditable]": "blur"
                }
            }
            if (!this._options["initialCopyDirection"]) {
                this._options["initialCopyDirection"] = n.ModelBinder.Constants.ModelToView
            }
        },
        _initializeAttributeBindings: function() {
            var t, n, r, i, s;
            for (t in this._attributeBindings) {
                n = this._attributeBindings[t];
                if (e.isString(n)) {
                    r = {
                        elementBindings: [{
                            selector: n
                        }]
                    }
                } else if (e.isArray(n)) {
                    r = {
                        elementBindings: n
                    }
                } else if (e.isObject(n)) {
                    r = {
                        elementBindings: [n]
                    }
                } else {
                    this._throwException("Unsupported type passed to Model Binder " + r)
                }
                for (i = 0; i < r.elementBindings.length; i++) {
                    s = r.elementBindings[i];
                    s.attributeBinding = r
                }
                r.attributeName = t;
                this._attributeBindings[t] = r
            }
        },
        _initializeDefaultBindings: function() {
            var e, n, r, i, s;
            this._attributeBindings = {};
            n = t("[" + this._options["boundAttribute"] + "]", this._rootEl);
            for (e = 0; e < n.length; e++) {
                r = n[e];
                i = t(r).attr(this._options["boundAttribute"]);
                if (!this._attributeBindings[i]) {
                    s = {
                        attributeName: i
                    };
                    s.elementBindings = [{
                        attributeBinding: s,
                        boundEls: [r]
                    }];
                    this._attributeBindings[i] = s
                } else {
                    this._attributeBindings[i].elementBindings.push({
                        attributeBinding: this._attributeBindings[i],
                        boundEls: [r]
                    })
                }
            }
        },
        _initializeElBindings: function() {
            var e, n, r, i, s, o, u;
            for (e in this._attributeBindings) {
                n = this._attributeBindings[e];
                for (r = 0; r < n.elementBindings.length; r++) {
                    i = n.elementBindings[r];
                    if (i.selector === "") {
                        s = t(this._rootEl)
                    } else {
                        s = t(i.selector, this._rootEl)
                    }
                    if (s.length === 0) {
                        this._throwException("Bad binding found. No elements returned for binding selector " + i.selector)
                    } else {
                        i.boundEls = [];
                        for (o = 0; o < s.length; o++) {
                            u = s[o];
                            i.boundEls.push(u)
                        }
                    }
                }
            }
        },
        _bindModelToView: function() {
            this._model.on("change", this._onModelChange, this);
            if (this._options["initialCopyDirection"] === n.ModelBinder.Constants.ModelToView) {
                this.copyModelAttributesToView()
            }
        },
        copyModelAttributesToView: function(t) {
            var n, r;
            for (n in this._attributeBindings) {
                if (t === undefined || e.indexOf(t, n) !== -1) {
                    r = this._attributeBindings[n];
                    this._copyModelToView(r)
                }
            }
        },
        copyViewValuesToModel: function() {
            var e, n, r, i, s, o;
            for (e in this._attributeBindings) {
                n = this._attributeBindings[e];
                for (r = 0; r < n.elementBindings.length; r++) {
                    i = n.elementBindings[r];
                    if (this._isBindingUserEditable(i)) {
                        if (this._isBindingRadioGroup(i)) {
                            o = this._getRadioButtonGroupCheckedEl(i);
                            if (o) {
                                this._copyViewToModel(i, o)
                            }
                        } else {
                            for (s = 0; s < i.boundEls.length; s++) {
                                o = t(i.boundEls[s]);
                                if (this._isElUserEditable(o)) {
                                    this._copyViewToModel(i, o)
                                }
                            }
                        }
                    }
                }
            }
        },
        _unbindModelToView: function() {
            if (this._model) {
                this._model.off("change", this._onModelChange);
                this._model = undefined
            }
        },
        _bindViewToModel: function() {
            e.each(this._options["changeTriggers"], function(e, n) {
                t(this._rootEl).delegate(n, e, this._onElChanged)
            }, this);
            if (this._options["initialCopyDirection"] === n.ModelBinder.Constants.ViewToModel) {
                this.copyViewValuesToModel()
            }
        },
        _unbindViewToModel: function() {
            if (this._options && this._options["changeTriggers"]) {
                e.each(this._options["changeTriggers"], function(e, n) {
                    t(this._rootEl).undelegate(n, e, this._onElChanged)
                }, this)
            }
        },
        _onElChanged: function(e) {
            var n, r, i, s;
            n = t(e.target)[0];
            r = this._getElBindings(n);
            for (i = 0; i < r.length; i++) {
                s = r[i];
                if (this._isBindingUserEditable(s)) {
                    this._copyViewToModel(s, n)
                }
            }
        },
        _isBindingUserEditable: function(e) {
            return e.elAttribute === undefined || e.elAttribute === "text" || e.elAttribute === "html"
        },
        _isElUserEditable: function(e) {
            var t = e.attr("contenteditable");
            return t || e.is("input") || e.is("select") || e.is("textarea")
        },
        _isBindingRadioGroup: function(e) {
            var n, r;
            var i = e.boundEls.length > 0;
            for (n = 0; n < e.boundEls.length; n++) {
                r = t(e.boundEls[n]);
                if (r.attr("type") !== "radio") {
                    i = false;
                    break
                }
            }
            return i
        },
        _getRadioButtonGroupCheckedEl: function(e) {
            var n, r;
            for (n = 0; n < e.boundEls.length; n++) {
                r = t(e.boundEls[n]);
                if (r.attr("type") === "radio" && r.attr("checked")) {
                    return r
                }
            }
            return undefined
        },
        _getElBindings: function(e) {
            var t, n, r, i, s, o;
            var u = [];
            for (t in this._attributeBindings) {
                n = this._attributeBindings[t];
                for (r = 0; r < n.elementBindings.length; r++) {
                    i = n.elementBindings[r];
                    for (s = 0; s < i.boundEls.length; s++) {
                        o = i.boundEls[s];
                        if (o === e) {
                            u.push(i)
                        }
                    }
                }
            }
            return u
        },
        _onModelChange: function() {
            var e, t;
            for (e in this._model.changedAttributes()) {
                t = this._attributeBindings[e];
                if (t) {
                    this._copyModelToView(t)
                }
            }
        },
        _copyModelToView: function(e) {
            var r, i, s, o, u, a;
            u = this._model.get(e.attributeName);
            for (r = 0; r < e.elementBindings.length; r++) {
                i = e.elementBindings[r];
                for (s = 0; s < i.boundEls.length; s++) {
                    o = i.boundEls[s];
                    if (!o._isSetting) {
                        a = this._getConvertedValue(n.ModelBinder.Constants.ModelToView, i, u);
                        this._setEl(t(o), i, a)
                    }
                }
            }
        },
        _setEl: function(e, t, n) {
            if (t.elAttribute) {
                this._setElAttribute(e, t, n)
            } else {
                this._setElValue(e, n)
            }
        },
        _setElAttribute: function(t, r, i) {
            switch (r.elAttribute) {
                case "html":
                    t.html(i);
                    break;
                case "text":
                    t.text(i);
                    break;
                case "enabled":
                    t.prop("disabled", !i);
                    break;
                case "displayed":
                    t[i ? "show" : "hide"]();
                    break;
                case "hidden":
                    t[i ? "hide" : "show"]();
                    break;
                case "css":
                    t.css(r.cssAttribute, i);
                    break;
                case "class":
                    var s = this._model.previous(r.attributeBinding.attributeName);
                    var o = this._model.get(r.attributeBinding.attributeName);
                    if (!e.isUndefined(s) || !e.isUndefined(o)) {
                        s = this._getConvertedValue(n.ModelBinder.Constants.ModelToView, r, s);
                        t.removeClass(s)
                    }
                    if (i) {
                        t.addClass(i)
                    }
                    break;
                default:
                    t.attr(r.elAttribute, i)
            }
        },
        _setElValue: function(e, t) {
            if (e.attr("type")) {
                switch (e.attr("type")) {
                    case "radio":
                        e.prop("checked", e.val() === t);
                        break;
                    case "checkbox":
                        e.prop("checked", !! t);
                        break;
                    case "file":
                        break;
                    default:
                        e.val(t)
                }
            } else if (e.is("input") || e.is("select") || e.is("textarea")) {
                e.val(t || (t === 0 ? "0" : ""))
            } else {
                e.text(t || (t === 0 ? "0" : ""))
            }
        },
        _copyViewToModel: function(e, r) {
            var i, s, o;
            if (!r._isSetting) {
                r._isSetting = true;
                i = this._setModel(e, t(r));
                r._isSetting = false;
                if (i && e.converter) {
                    s = this._model.get(e.attributeBinding.attributeName);
                    o = this._getConvertedValue(n.ModelBinder.Constants.ModelToView, e, s);
                    this._setEl(t(r), e, o)
                }
            }
        },
        _getElValue: function(e, t) {
            switch (t.attr("type")) {
                case "checkbox":
                    return t.prop("checked") ? true : false;
                default:
                    if (t.attr("contenteditable") !== undefined) {
                        return t.html()
                    } else {
                        return t.val()
                    }
            }
        },
        _setModel: function(e, t) {
            var r = {};
            var i = this._getElValue(e, t);
            i = this._getConvertedValue(n.ModelBinder.Constants.ViewToModel, e, i);
            r[e.attributeBinding.attributeName] = i;
            return this._model.set(r, this._options["modelSetOptions"])
        },
        _getConvertedValue: function(e, t, n) {
            if (t.converter) {
                n = t.converter(e, n, t.attributeBinding.attributeName, this._model, t.boundEls)
            } else if (this._options["converter"]) {
                n = this._options["converter"](e, n, t.attributeBinding.attributeName, this._model, t.boundEls)
            }
            return n
        },
        _throwException: function(e) {
            if (this._options.suppressThrows) {
                if (console && console.error) {
                    console.error(e)
                }
            } else {
                throw e
            }
        }
    });
    n.ModelBinder.CollectionConverter = function(t) {
        this._collection = t;
        if (!this._collection) {
            throw "Collection must be defined"
        }
        e.bindAll(this, "convert")
    };
    e.extend(n.ModelBinder.CollectionConverter.prototype, {
        convert: function(e, t) {
            if (e === n.ModelBinder.Constants.ModelToView) {
                return t ? t.id : undefined
            } else {
                return this._collection.get(t)
            }
        }
    });
    n.ModelBinder.createDefaultBindings = function(e, n, r, i) {
        var s, o, u, a;
        var f = {};
        s = t("[" + n + "]", e);
        for (o = 0; o < s.length; o++) {
            u = s[o];
            a = t(u).attr(n);
            if (!f[a]) {
                var l = {
                    selector: "[" + n + '="' + a + '"]'
                };
                f[a] = l;
                if (r) {
                    f[a].converter = r
                }
                if (i) {
                    f[a].elAttribute = i
                }
            }
        }
        return f
    };
    n.ModelBinder.combineBindings = function(t, n) {
        e.each(n, function(e, n) {
            var r = {
                selector: e.selector
            };
            if (e.converter) {
                r.converter = e.converter
            }
            if (e.elAttribute) {
                r.elAttribute = e.elAttribute
            }
            if (!t[n]) {
                t[n] = r
            } else {
                t[n] = [t[n], r]
            }
        });
        return t
    };
    return n.ModelBinder
})