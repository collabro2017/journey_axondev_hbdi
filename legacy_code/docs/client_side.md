## Css Modules
In this project we're experimenting with the use of css modules on the rails side. To do this we're making use of the way that the `postcss-loader` can output a css modules JSON file next to any css files it processes.

Through a simple appliction_helper, we can create a nice syntax for using this JSON file to render modularlized class names server side. The syntax is something like this

    <% styles = css_module("component/styles") %>
    <div class="<%= styles.header %>" ></div>

  Where `component\styles` is the path to the css file relative to the `app/javascript/packs` folder
