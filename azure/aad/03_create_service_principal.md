---
wts:
    title: '03 - Create service principal (10 min)'   
    module: 'Module 01 - Azure Active Directory (Azure AD)'
---

# Objectives

In this lab, you will:

+ Task 1: Create a service principal

# Lab 01: Create a Service Principal

This article shows you how to create a new Azure Active Directory (Azure AD) application and service principal that can be used with the role-based access control. When you have applications, hosted services, or automated tools that needs to access or modify resources, you can create an identity for the app. This identity is known as a service principal. Access to resources is restricted by the roles assigned to the service principal, giving you control over which resources can be accessed and at which level. For security reasons, it's always recommended to use service principals with automated tools rather than allowing them to log in with a user identity.

This article shows you how to use the portal to create the service principal in the Azure portal. It focuses on a single-tenant application where the application is intended to run within only one organization. You typically use single-tenant applications for line-of-business applications that run within your organization.

## Task 01: Create a Service Principal

Let's jump straight into creating the identity. If you run into a problem, check the [required permissions](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal#permissions-required-for-registering-an-app) to make sure your account can create the identity.

1. Sign in to your Azure Account through the [Azure portal](https://portal.azure.com/).

2. Select Azure Active Directory.

3. Select App registrations. ![app reg home](images/16_app_home.jpg)

4. Select New registration. ![New reg](images/17_register_an_app.jpg)

5. Name the application, select Register. ![register](images/18_sp_details.jpg)
6. Select **Certificates & Secrets** from the left side menu. ![data](images/19_client_secret_home.jpg)
7. Select **New Client Secret**, enter and name and **Add** ![data](images/20_create_secret.jpg)
8. Copy the Client Secret. ![data](images/21_created_secret.jpg)

#### Review

In this lab, you have:

- Created an AAD application and added a secret.