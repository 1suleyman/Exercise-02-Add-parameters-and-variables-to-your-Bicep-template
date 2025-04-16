# 🧠 Make Your Bicep Templates Flexible with Parameters and Variables

> **Bitesize Lesson 🍬**  
This one’s all about adding some much-needed **flexibility and reusability** to your Bicep templates — because hardcoding everything is soooo 2005.  
You’ll learn how to use **parameters**, **variables**, and **expressions** to make your templates smarter, adaptable, and way easier to reuse across environments.  
Also: Hi, future-me 👋 — this is your gentle reminder why we made it all so configurable.

---

## 🎯 Why Flexibility Matters

You’re launching toys like hotcakes at your company 🧸🚀 — and each one needs:
- Its own **unique resource names**
- Deployment to **different regions**
- Different **SKUs** depending on whether it’s for testing or production

Hardcoding all that = 😩  
Using parameters + variables = 🎯

---

## 🧩 What Are Parameters and Variables?

### 🔧 Parameters  
Think of these as **inputs** — things you expect to change **per deployment**, like:
- Resource names
- Location
- Environment type (e.g. prod vs nonprod)
- SKUs or settings

```bicep
param appServiceAppName string
```

You can give them **default values**, too:

```bicep
param appServiceAppName string = 'toy-product-launch-1'
```

⚠️ Heads up: names like this need to be **unique**, so avoid hardcoding unless you're using something like `uniqueString()` (more on that below!).

---

### 🧮 Variables  
Variables are for **internal calculations** or values you want to reuse within the template.

```bicep
var appServicePlanName = 'toy-product-launch-plan'
```

No type needed — Bicep figures it out. You can even build more complex logic into them using expressions.

---

## 💡 Expressions – Let Bicep Do the Thinking

You don’t want to manually define everything — Bicep can compute things for you with **expressions**.

### 🔁 Example: Auto-detect Resource Group Location

```bicep
param location string = resourceGroup().location
```

Now, you can reference `location` in all your resources, and they’ll deploy in the same region as the resource group — unless someone overrides it.

---

## 🆎 Unique Names Made Easy

Let’s say you need a unique name for a **storage account** (which needs globally unique names 😅). Use the `uniqueString()` function like this:

```bicep
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
```

This gives you:
- A consistent name for the **same group**
- A different name across **different groups** or **subscriptions**

Bonus: it's still readable and makes sense. 👌

---

## 💬 Conditional Resource Configs with Ternary Expressions

You want different SKUs based on environment type?

```bicep
@allowed([
  'nonprod'
  'prod'
])
param environmentType string
```

Then use variables to switch config based on that:

```bicep
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'F1'
```

🧠 Translated:  
- If it’s **prod**, use premium SKUs.  
- If it’s **nonprod**, go cheap and cheerful.

This avoids needing 10+ parameters — cleaner, easier, and business-rule-ready.

---

## 🏗️ Use These Values in Resources

Use your parameters and variables like so:

```bicep
resource appServiceApp 'Microsoft.Web/sites@2024-04-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
```

No more hardcoded values — just clean, dynamic Bicep!

---

## ⚠️ Naming Tips

- Use **descriptive names** for parameters and variables (no `x1` or `foo`).
- Avoid hardcoding **unique names** unless they include something like `uniqueString()`.
- Validate values with `@allowed` or add a default when it makes sense.

---

## 🎯 TL;DR Recap

- 🔧 **Parameters** = customizable inputs (passed in per deployment)
- 🧮 **Variables** = reusable values or expressions inside the template
- 🧠 **Expressions** = use logic to compute dynamic values
- 🎭 Use `uniqueString()` and interpolation (`${}`) to build meaningful, unique names
- ⚖️ Ternary expressions let you set logic-based values, like selecting SKUs by environment

---

With this setup, you can deploy your resources across **any product**, **any region**, and **any environment** without rewriting your template each time. 🧱✨

Nice work, future-me — and to anyone else reading: may your templates be dynamic, clean, and *never hardcoded*. 🚀
