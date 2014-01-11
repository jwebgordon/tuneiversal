// Backbone.CollectionBinder v1.0.5
// (c) 2013 Bart Wood
// Distributed Under MIT License

(function(e, t, n) {
    if (!n) {
        throw "Please include Backbone.js before Backbone.ModelBinder.js"
    }
    if (!n.ModelBinder) {
        throw "Please include Backbone.ModelBinder.js before Backbone.CollectionBinder.js"
    }
    n.CollectionBinder = function(t, r) {
        e.bindAll.apply(e, [this].concat(e.functions(this)));
        this._elManagers = {};
        this._elManagerFactory = t;
        if (!this._elManagerFactory) throw "elManagerFactory must be defined.";
        this._elManagerFactory.trigger = this.trigger;
        this._options = e.extend({}, n.CollectionBinder.options, r)
    };
    n.CollectionBinder.SetOptions = function(e) {
        n.CollectionBinder.options = e
    };
    n.CollectionBinder.VERSION = "1.0.5";
    e.extend(n.CollectionBinder.prototype, n.Events, {
        bind: function(e, t) {
            this.unbind();
            if (!e) throw "collection must be defined";
            if (!t) throw "parentEl must be defined";
            this._collection = e;
            this._elManagerFactory._setParentEl(t);
            this._onCollectionReset();
            this._collection.on("add", this._onCollectionAdd, this);
            this._collection.on("remove", this._onCollectionRemove, this);
            this._collection.on("reset", this._onCollectionReset, this);
            this._collection.on("sort", this._onCollectionSort, this)
        },
        unbind: function() {
            if (this._collection !== undefined) {
                this._collection.off("add", this._onCollectionAdd);
                this._collection.off("remove", this._onCollectionRemove);
                this._collection.off("reset", this._onCollectionReset);
                this._collection.off("sort", this._onCollectionSort)
            }
            this._removeAllElManagers()
        },
        getManagerForEl: function(t) {
            var n, r, i = e.values(this._elManagers);
            for (n = 0; n < i.length; n++) {
                r = i[n];
                if (r.isElContained(t)) {
                    return r
                }
            }
            return undefined
        },
        getManagerForModel: function(t) {
            return this._elManagers[e.isObject(t) ? t.cid : t]
        },
        _onCollectionAdd: function(e) {
            this._elManagers[e.cid] = this._elManagerFactory.makeElManager(e);
            this._elManagers[e.cid].createEl();
            if (this._options["autoSort"]) {
                this.sortRootEls()
            }
        },
        _onCollectionRemove: function(e) {
            this._removeElManager(e)
        },
        _onCollectionReset: function() {
            this._removeAllElManagers();
            this._collection.each(function(e) {
                this._onCollectionAdd(e)
            }, this);
            this.trigger("elsReset", this._collection)
        },
        _onCollectionSort: function() {
            if (this._options["autoSort"]) {
                this.sortRootEls()
            }
        },
        _removeAllElManagers: function() {
            e.each(this._elManagers, function(e) {
                e.removeEl();
                delete this._elManagers[e._model.cid]
            }, this);
            delete this._elManagers;
            this._elManagers = {}
        },
        _removeElManager: function(e) {
            if (this._elManagers[e.cid] !== undefined) {
                this._elManagers[e.cid].removeEl();
                delete this._elManagers[e.cid]
            }
        },
        sortRootEls: function() {
            this._collection.each(function(e, n) {
                var r = this.getManagerForModel(e);
                if (r) {
                    var i = r.getEl();
                    var s = t(this._elManagerFactory._getParentEl()).children();
                    if (s[n] !== i[0]) {
                        i.detach();
                        i.insertBefore(s[n])
                    }
                }
            }, this)
        }
    });
    n.CollectionBinder.ElManagerFactory = function(t, n) {
        e.bindAll.apply(e, [this].concat(e.functions(this)));
        this._elHtml = t;
        this._bindings = n;
        if (!e.isFunction(this._elHtml) && !e.isString(this._elHtml)) throw "elHtml must be a compliled template or an html string"
    };
    e.extend(n.CollectionBinder.ElManagerFactory.prototype, {
        _setParentEl: function(e) {
            this._parentEl = e
        },
        _getParentEl: function() {
            return this._parentEl
        },
        makeElManager: function(r) {
            var i = {
                _model: r,
                createEl: function() {
                    this._el = e.isFunction(this._elHtml) ? t(this._elHtml({
                        model: this._model.toJSON()
                    })) : t(this._elHtml);
                    t(this._parentEl).append(this._el);
                    if (this._bindings) {
                        if (e.isString(this._bindings)) {
                            this._modelBinder = new n.ModelBinder;
                            this._modelBinder.bind(this._model, this._el, n.ModelBinder.createDefaultBindings(this._el, this._bindings))
                        } else if (e.isObject(this._bindings)) {
                            this._modelBinder = new n.ModelBinder;
                            this._modelBinder.bind(this._model, this._el, this._bindings)
                        } else {
                            throw "Unsupported bindings type, please use a boolean or a bindings hash"
                        }
                    }
                    this.trigger("elCreated", this._model, this._el)
                },
                removeEl: function() {
                    if (this._modelBinder !== undefined) {
                        this._modelBinder.unbind()
                    }
                    this._el.remove();
                    this.trigger("elRemoved", this._model, this._el)
                },
                isElContained: function(e) {
                    return this._el === e || t(this._el).has(e).length > 0
                },
                getModel: function() {
                    return this._model
                },
                getEl: function() {
                    return this._el
                }
            };
            e.extend(i, this);
            return i
        }
    });
    n.CollectionBinder.ViewManagerFactory = function(t) {
        e.bindAll.apply(e, [this].concat(e.functions(this)));
        this._viewCreator = t;
        if (!e.isFunction(this._viewCreator)) throw "viewCreator must be a valid function that accepts a model and returns a backbone view"
    };
    e.extend(n.CollectionBinder.ViewManagerFactory.prototype, {
        _setParentEl: function(e) {
            this._parentEl = e
        },
        _getParentEl: function() {
            return this._parentEl
        },
        makeElManager: function(n) {
            var r = {
                _model: n,
                createEl: function() {
                    this._view = this._viewCreator(n);
                    t(this._parentEl).append(this._view.render(this._model).el);
                    this.trigger("elCreated", this._model, this._view)
                },
                removeEl: function() {
                    if (this._view.close !== undefined) {
                        this._view.close()
                    } else {
                        this._view.$el.remove();
                        console.log("warning, you should implement a close() function for your view, you might end up with zombies")
                    }
                    this.trigger("elRemoved", this._model, this._view)
                },
                isElContained: function(e) {
                    return this._view.el === e || this._view.$el.has(e).length > 0
                },
                getModel: function() {
                    return this._model
                },
                getView: function() {
                    return this._view
                },
                getEl: function() {
                    return this._view.$el
                }
            };
            e.extend(r, this);
            return r
        }
    })
}).call(this, _, jQuery, Backbone)