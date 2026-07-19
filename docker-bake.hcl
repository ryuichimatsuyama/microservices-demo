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

  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/frontend:cache"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/frontend:cache,mode=max"
  ]
}

# ----------------------
# Cart
# ----------------------
target "cartservice" {
  context = "./src/cartservice/src"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/cartservice:${TAG}"]

  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/cartservice:cache"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/cartservice:cache,mode=max"
  ]
}

# ----------------------
# Product Catalog
# ----------------------
target "productcatalogservice" {
  context = "./src/productcatalogservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/productcatalogservice:${TAG}"]

  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/productcatalogservice:cache"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/productcatalogservice:cache,mode=max"
  ]
}

# ----------------------
# Currency
# ----------------------
target "currencyservice" {
  context = "./src/currencyservice"
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]

  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/currencyservice:cache"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/currencyservice:cache,mode=max"
  ]
}

# ----------------------
# Payment
# ----------------------
target "paymentservice" {
  context = "./src/paymentservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/paymentservice:${TAG}"]

  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/paymentservice:cache"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/paymentservice:cache,mode=max"
  ]
}

# ----------------------
# Shipping
# ----------------------
target "shippingservice" {
  context = "./src/shippingservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/shippingservice:${TAG}"]

  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/shippingservice:cache"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/shippingservice:cache,mode=max"
  ]
}

# ----------------------
# Email
# ----------------------
target "emailservice" {
  context = "./src/emailservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/emailservice:${TAG}"]

  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/emailservice:cache"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/emailservice:cache,mode=max"
  ]
}

# ----------------------
# Checkout
# ----------------------
target "checkoutservice" {
  context = "./src/checkoutservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/checkoutservice:${TAG}"]

  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/checkoutservice:cache"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/checkoutservice:cache,mode=max"
  ]
}

# ----------------------
# Recommendation
# ----------------------
target "recommendationservice" {
  context = "./src/recommendationservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/recommendationservice:${TAG}"]

  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/recommendationservice:cache"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/recommendationservice:cache,mode=max"
  ]
}

# ----------------------
# Ad Service
# ----------------------
target "adservice" {
  context = "./src/adservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/adservice:${TAG}"]

  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/adservice:cache"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/adservice:cache,mode=max"
  ]
}

# ----------------------
# shoppingassistantservice
# ----------------------
target "shoppingassistantservice" {
  context = "./src/shoppingassistantservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/shoppingassistantservice:${TAG}"]

  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/shoppingassistantservice:cache"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/shoppingassistantservice:cache,mode=max"
  ]
}

# ----------------------
# loadgenerator
# ----------------------
target "loadgenerator" {
  context = "./src/loadgenerator"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/loadgenerator:${TAG}"]

  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/loadgenerator:cache"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/loadgenerator:cache,mode=max"
  ]
}

target "_common" {
  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/cache:latest"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/cache:latest,mode=max"
  ]
}

