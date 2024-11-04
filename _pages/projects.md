---
layout: page
title: projects
permalink: /projects/
description: Jobs with more relevance.
nav: true
nav_order: 3
horizontal: false
---

<!-- pages/projects.md -->
<div class="Projects">
  <!-- Mostrar solo el proyecto específico -->
  {% assign project = site.projects | where: "title", "Proyecto Arquitectura de Computadores" | first %}
  {% if project %}
    {% if page.horizontal %}
      <div class="container">
        <div class="row row-cols-1 row-cols-md-2">
          {% include projects_horizontal.liquid project=project %}
        </div>
      </div>
    {% else %}
      <div class="row row-cols-1 row-cols-md-3">
        {% include projects.liquid project=project %}
      </div>
    {% endif %}
  {% else %}
    <p>No projects found.</p>
  {% endif %}
</div>