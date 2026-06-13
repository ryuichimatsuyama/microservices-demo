variable "TAG" {
  default = "latest"
}

group "default" {
  targets = [
    "frontend",
    "cartservice",
    "productcatalogservice",
    "currencyservice",
    "paymentservice",
    "shippingservice",
    "emailservice",
    "checkoutservice",
    "recommendationservice",
    "adservice",
    "shoppingassistantservice",
    "loadgenerator"
  ]
}

# ----------------------
# Frontend
# ----------------------
target "frontend" {
  context = "./src/frontend"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/frontend:${TAG}"]

  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
}

# ----------------------
# Cart
# ----------------------
target "cartservice" {
  context = "./src/cartservice/src"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/cartservice:${TAG}"]

  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
}

# ----------------------
# Product Catalog
# ----------------------
target "productcatalogservice" {
  context = "./src/productcatalogservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/productcatalogservice:${TAG}"]

  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
}

# ----------------------
# Currency
# ----------------------
target "currencyservice" {
  context = "./src/currencyservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/currencyservice:${TAG}"]

  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
}

# ----------------------
# Payment
# ----------------------
target "paymentservice" {
  context = "./src/paymentservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/paymentservice:${TAG}"]

  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
}

# ----------------------
# Shipping
# ----------------------
target "shippingservice" {
  context = "./src/shippingservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/shippingservice:${TAG}"]

  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
}

# ----------------------
# Email
# ----------------------
target "emailservice" {
  context = "./src/emailservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/emailservice:${TAG}"]

  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
}

# ----------------------
# Checkout
# ----------------------
target "checkoutservice" {
  context = "./src/checkoutservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/checkoutservice:${TAG}"]

  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
}

# ----------------------
# Recommendation
# ----------------------
target "recommendationservice" {
  context = "./src/recommendationservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/recommendationservice:${TAG}"]

  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
}

# ----------------------
# Ad Service
# ----------------------
target "adservice" {
  context = "./src/adservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/adservice:${TAG}"]

  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
}

# ----------------------
# shoppingassistantservice
# ----------------------
target "shoppingassistantservice" {
  context = "./src/shoppingassistantservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/shoppingassistantservice:${TAG}"]

  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
}

# ----------------------
# loadgenerator
# ----------------------
target "loadgenerator" {
  context = "./src/loadgenerator"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/loadgenerator:${TAG}"]

  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
}
