---
title: Online Hosted Instructions
permalink: index.html
layout: home
---

# Content Directory

Hyperlinks to each of the walkthroughs. Instructors may choose to use the walkthrough as a demonstration or a student lab.

## Azure Labs

Content Courtesy:
+ [MicrosoftLearning](https://github.com/MicrosoftLearning)
  
+ [Azure Documentation](https://docs.microsoft.com/en-us/azure/)

### AAD

{% assign wts = site.pages | where_exp:"page", "page.url contains '/azure/aad'" %}
| Module | Walkthrough |
| --- | --- | 
{% for activity in wts %}| {{ activity.wts.module }} | [{{ activity.wts.title }}{% if activity.wts.type %} - {{ activity.wts.type }}{% endif %}]({{ site.github.url }}{{ activity.url }}) |
{% endfor %}

### Virtual Networking

{% assign wts = site.pages | where_exp:"page", "page.url contains '/azure/vnet'" %}
| Module | Walkthrough |
| --- | --- | 
{% for activity in wts %}| {{ activity.wts.module }} | [{{ activity.wts.title }}{% if activity.wts.type %} - {{ activity.wts.type }}{% endif %}]({{ site.github.url }}{{ activity.url }}) |
{% endfor %}
