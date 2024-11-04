---
layout: page
title: Projects
permalink: /projects/
description: A collection of my projects.
nav: true
nav_order: 3
horizontal: false
---

<!-- Projects Page -->
<h2>GitHub Repositories</h2>
<div class="container">
  <div class="row row-cols-1 row-cols-md-3">
    {% for repo in site.data.repositories.repositories %}
      <div class="col mb-4">
        <div class="card h-100">
          <img src="{{ repo.image }}" class="card-img-top" alt="{{ repo.name }}">
          <div class="card-body">
            <h5 class="card-title">{{ repo.name }}</h5>
            <p class="card-text">{{ repo.description }}</p>
            <a href="{{ repo.url }}" class="btn btn-primary" target="_blank">View Repository</a>
          </div>
        </div>
      </div>
    {% endfor %}
  </div>
</div>