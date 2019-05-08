#if !macro
typedef Rule = Style & {
  @:optional final children:DynamicAccess<Rule>;
}
#end
class Css {
  #if !macro
  static var sheet:CSSStyleSheet = {
    var style = document.createStyleElement();
    document.head.appendChild(style);
    cast document.styleSheets[document.styleSheets.length - 1];
  }

  static var classesCounter = 0;
  static function makeSheet(s:Rule):ClassName {
    function make(s:Rule, name:String) {
      var dummy = document.createDivElement();
      var src:DynamicAccess<Any> = cast s;
      
      for (key => value in src)
        if (key != 'children') 
          Reflect.setField(dummy.style, key, value);

      sheet.insertRule('$name { ${dummy.style.cssText} }', sheet.cssRules.length);
      
      switch s.children {
        case null:
        case children:
          for (selector => rule in children)
            make(rule, switch selector.split('&') {
              case [_]: '$name $selector';
              case parts: parts.join(name);
            });            
      }

    }
    
    var name = 's${classesCounter++}';
    make(s, '.$name');
    return name;
  }
  #end
  macro static public function make(e:haxe.macro.Expr) {
    function regroup(e:Expr) 
      return switch e.expr {
        case EObjectDecl(fields):
          var ret = [],
              children = [];
          for (f in fields)
            switch f.expr {
              default: ret.push(f); 
              case { expr: EObjectDecl(_) }:
                children.push({
                  field: f.field,
                  expr: regroup(f.expr),
                  quotes: f.quotes
                });
            }

          if (children.length > 0)
            ret.push({
              field: 'children',
              expr: EObjectDecl(children).at(e.pos)
            });

          EObjectDecl(ret).at(e.pos).as(macro : Css.Rule);
        default: e.reject('object literal expected');
      }

    switch e {
      case macro -$v: e = v;
      default:
    }

    return macro @:pos(e.pos) @:privateAccess Css.makeSheet(${regroup(e)});
  }
}