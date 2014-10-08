# thymeleaf-rb
## Ruby port of the Thymeleaf natural templating engine

Thymeleaf.rb aims to be a ruby adaptation of [Thymeleaf](http://www.thymeleaf.org), a
natural templating engine.

**This is a Work In Progress Project**, now at the definition stage. The idea is
to port the Thymeleaf Java templating engine to Ruby adapting its core features and
philosophy to the Ruby ecosystem. We will not do a direct translation (which is impossible for
the most part).

## Expected usage

Add the gem to your `Gemfile` and get ready to rock.

```ruby
gem 'thymeleaf-rb'
```

To use a template

```ruby
Thymeleaf::Template.new('path/to/template', context).render
```

A thymeleaf template could be something like this:

```xml
<!DOCTYPE html>
<html>
  <head>
    <title th-text="#{layout.title}"></title>
    <meta charset=UTF-8" />
  </head>

  <tbody>
    <tr th-each="prod : ${all_products}">
      <td th-text="${prod.name}">Oranges</td>
      <td th-text="${prod.price}">0.99</td>
    </tr>
  </tbody>
</html>
```

To find more about the Thymeleaf syntax and capabilities read the 
[Project's documentation](http://www.thymeleaf.org/documentation.html).


## What needs to be done (at least)

* Initial implementation of the core features (not aiming for optimization)
* Test/Benchmark support and suites
* Basic documentation


## Contributing and help

We are currently looking for help, our idea is to find a college student willing to help
us bootstrap the project as their end of degree/career project (the original call for help is
[here](http://4trabes.com/2014/07/20/se-busca-estudiante-para-proyecto-de-fin-de-carrera-thymeleaf-dot-rb/)
,written in spanish, targeted mainly to [FIC](http://www.fic.udc.es) students). However, any help 
would be appreciated.

Contact us at [contact@trabesoluciones.com](mailto:contact@trabesoluciones.com) if you are interested.
