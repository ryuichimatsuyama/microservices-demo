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
  platforms = ["linux/amd64", "linux/arm64"]

  inherits = ["_common"]
}

# ----------------------
# Cart
# ----------------------
target "cartservice" {
  context = "./src/cartservice/src"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/cartservice:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]

  inherits = ["_common"]
}

# ----------------------
# Product Catalog
# ----------------------
target "productcatalogservice" {
  context = "./src/productcatalogservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/productcatalogservice:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]

  inherits = ["_common"]
}

# ----------------------
# Currency
# ----------------------
target "currencyservice" {
  context = "./src/currencyservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/currencyservice:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]

  inherits = ["_common"]
}

# ----------------------
# Payment
# ----------------------
target "paymentservice" {
  context = "./src/paymentservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/paymentservice:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]

  inherits = ["_common"]
}

# ----------------------
# Shipping
# ----------------------
target "shippingservice" {
  context = "./src/shippingservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/shippingservice:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]

  inherits = ["_common"]
}

# ----------------------
# Email
# ----------------------
target "emailservice" {
  context = "./src/emailservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/emailservice:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]

  inherits = ["_common"]
}

# ----------------------
# Checkout
# ----------------------
target "checkoutservice" {
  context = "./src/checkoutservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/checkoutservice:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]

  inherits = ["_common"]
}

# ----------------------
# Recommendation
# ----------------------
target "recommendationservice" {
  context = "./src/recommendationservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/recommendationservice:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]

  inherits = ["_common"]
}

# ----------------------
# Ad Service
# ----------------------
target "adservice" {
  context = "./src/adservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/adservice:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]

  inherits = ["_common"]
}

# ----------------------
# shoppingassistantservice
# ----------------------
target "shoppingassistantservice" {
  context = "./src/shoppingassistantservice"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/shoppingassistantservice:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]

  inherits = ["_common"]
}

# ----------------------
# loadgenerator
# ----------------------
target "loadgenerator" {
  context = "./src/loadgenerator"
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/ryuichimatsuyama/loadgenerator:${TAG}"]
  platforms = ["linux/amd64", "linux/arm64"]

  inherits = ["_common"]
}

target "_common" {
  cache-from = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/cache:latest"
  ]

  cache-to = [
    "type=registry,ref=ghcr.io/ryuichimatsuyama/cache:latest,mode=max"
  ]
}
