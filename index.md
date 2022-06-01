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

### Azure Active Directory (AAD)

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

### Compute

{% assign wts = site.pages | where_exp:"page", "page.url contains '/azure/compute'" %}
| Module | Walkthrough |
| --- | --- | 
{% for activity in wts %}| {{ activity.wts.module }} | [{{ activity.wts.title }}{% if activity.wts.type %} - {{ activity.wts.type }}{% endif %}]({{ site.github.url }}{{ activity.url }}) |
{% endfor %}

### Azure Resource Manager (ARM)

{% assign wts = site.pages | where_exp:"page", "page.url contains '/azure/arm'" %}
| Module | Walkthrough |
| --- | --- | 
{% for activity in wts %}| {{ activity.wts.module }} | [{{ activity.wts.title }}{% if activity.wts.type %} - {{ activity.wts.type }}{% endif %}]({{ site.github.url }}{{ activity.url }}) |
{% endfor %}

### Azure Logging and Monitoring

{% assign wts = site.pages | where_exp:"page", "page.url contains '/azure/logging_and_monitoring'" %}
| Module | Walkthrough |
| --- | --- | 
{% for activity in wts %}| {{ activity.wts.module }} | [{{ activity.wts.title }}{% if activity.wts.type %} - {{ activity.wts.type }}{% endif %}]({{ site.github.url }}{{ activity.url }}) |
{% endfor %}