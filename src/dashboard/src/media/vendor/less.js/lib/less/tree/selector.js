(function (tree) {

tree.Selector = function (elements) {
    this.elements = elements;
    if (this.elements[0].combinator.value === "") {
        this.elements[0].combinator.value = ' ';
    }
};
tree.Selector.prototype.match = function (other) {
    var len  = this.elements.length,
        olen = other.elements.length,
        max  = Math.min(len, olen);

    if (len < olen) {
        return false;
    } else {
        for (var i = 0; i < max; i++) {
            if (this.elements[i].value !== other.elements[i].value) {
                return false;
            }
        }
    }
    return true;
};
tree.Selector.prototype.toCSS = function (env) {
    if (this._css) { return this._css }

    return this._css = this.elements.map(function (e) {
        if (typeof(e) === 'string') {
            return ' ' + e.trim();
        } else {
            return e.toCSS(env);
        }
    }).join('');
};

})(require('less/tree'));
