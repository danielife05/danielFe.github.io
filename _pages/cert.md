---
layout: page
title: Certifications
permalink: /cert/
description: Certificates of completed courses(for now).
nav: true
nav_order: 4
---

<div class="gallery">
  <div class="gallery-item">
    <img src="{{ '/assets/img/py1.png' | relative_url }}" alt="Basic Python" width="204" height="auto" />
    <p>Basic Python</p>
  </div>
  <div class="gallery-item">
    <img src="{{ '/assets/img/py2.png' | relative_url }}" alt="Intermediate-Advanced Python" width="204" height="auto" />
    <p>Intermediate-Advanced Python</p>
  </div>
</div>

<style>
  .gallery {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 15px;
    padding: 20px;
  }

  .gallery-item {
    overflow: hidden;
    text-align: center;
  }

  .gallery-item img {
    width: 204px;
    height: auto;
    display: block;
    margin: 0 auto;
  }
</style>
