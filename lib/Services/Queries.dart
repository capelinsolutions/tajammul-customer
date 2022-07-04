class Queries {
  //username check query
  static String isUsernameUnique = """
  query isUnique(\$username: String!){
    isUsernameUnique(username: \$username)
      }
    """;

  //email check query
  static String isEmailUnique = """
  query isUnique(\$email: String!){
    isEmailUnique(email: \$email)
      }
    """;

  //create user query
  static String createUser = """
  mutation createUser(\$UserInput: UserInput){
       createUser(input: \$UserInput){
    data {
    userId
    }
  }
  }
  """;

  //create userTypes query
  static String getUserById = """
  query { 
   getUserById {
        userId
        phoneNumber
        status
        imagePath
        userName
        businesses{
          businessId
    businessDetails{
        inventoryList{
          products{
            imagePaths
            listImagePath
          }
        }
        servicesList {
            serviceName
            imagePaths
            description
            status
            price
            availableSlots
            discount
            discountedPrice
            likedCount
            purchasedCount
          }
      }
      isOpened
    timings {
      timings {
       monday {
        startTime
        endTime
      }
      tuesday {
        startTime
        endTime
      }
      wednesday { 
        startTime
        endTime
      }
      thursday {
        startTime
        endTime
      }
      friday {
        startTime
        endTime
      }
      saturday {
        startTime
        endTime
      }
      sunday {
        startTime
        endTime
      }
      }
     }
      businessInfo{
       name
       imagePath
       listImagePath
       address{
        street
        postalCode
        additionalAddress
        formatedAddress
        addressName
        residence
        area
        city
        province
        country
        latitude
        longitude
        addressType
       }
      }
        }
        addresses{
        isActive
           address{
              street
              postalCode
              additionalAddress
              formatedAddress
              residence
              area
              city
              province
              country
              latitude
              longitude
              addressName
              addressType
           }
        }
        email
        name{
          firstName
          lastName
        }
      }
    }""";

  //get phone number query
  static String getPhoneNumberByUser = """
  query getPhoneNumberByUser(\$user: String!){
       getPhoneNumberByUser(user: \$user)
  }
  """;

  //reset password
  static String forgotPassword = """
  mutation forgotPassword(\$newPassword: String!,\$user: String!){
       forgotPassword(newPassword:\$newPassword,user:\$user){
       status
       }
  }
  """;

  //change password
  static String changePassword = """
  mutation forgotPassword(\$newPassword: String!,\$currentPassword: String!){
       changePassword(newPassword:\$newPassword,currentPassword:\$currentPassword){
       status
       }
  }
  """;

  //get Categories by business
  static String getCategoriesByBusiness = """
  query getCategoriesByBusiness(\$businessId: String!){
       getCategoriesByBusiness(businessId:\$businessId){
       data
       }
  }
  """;

  //add user addresses
  static String addUserAddress = """
  mutation addUserAddress(\$userId: String!, \$addressInput: AddressInput!) {
     addUserAddress(userId:\$userId,input:\$addressInput) {
       data {
        userId
        phoneNumber
        status
        imagePath
        userName
        addresses{
        isActive
           address{
              street
              postalCode
              additionalAddress
              residence
              area
              city
              province
              country
              latitude
              longitude
              formatedAddress
              addressName
              addressType
           }
        }
        email
        name{
          firstName
          lastName
        }
      }
      }
    }""";

  //update user address
  static String updateUserAddress = """
  mutation updateUserAddress(\$userId: String!, \$addressInput: AddressInput!, \$index: Int!) {
       updateUserAddress(userId:\$userId,input:\$addressInput,index:\$index) {
       data {
        userId
        phoneNumber
        status
        imagePath
        userName
        addresses{
        isActive
           address{
              street
              postalCode
              additionalAddress
              formatedAddress
              addressName
              residence
              area
              city
              province
              country
              latitude
              longitude
              addressType
           }
        }
        email
        name{
          firstName
          lastName
        }
      }
      }
    }""";

  //delete user address
  static String deleteUserAddress = """
  mutation deleteUserAddress(\$userId: String!, \$addressInput: AddressInput!, \$index: Int!) {
       deleteUserAddress(userId:\$userId,input:\$addressInput,index:\$index) {
       data {
        userId
        phoneNumber
        status
        imagePath
        userName
        addresses{
        isActive
           address{
              street
              postalCode
              additionalAddress
              formatedAddress
              addressName
              residence
              area
              city
              province
              country
              latitude
              longitude
              addressType
           }
        }
        email
        name{
          firstName
          lastName
        }
      }
      }
    }""";

  //search by category
  static String searchByCategory = """
  query searchByCategory(\$categoryName: String!) {
       searchByCategory(categoryName:\$categoryName) {
       data 
       }
  }
  """;

  //search by product
  static String searchByProduct = """
  query searchByProduct(\$productName: String!) {
       searchByProduct(productName:\$productName) {
       data 
       }
  }
  """;

  //get product by category by business
  static String getProductsByCategoryInBusiness = """
  query getProductsByCategoryInBusiness(\$businessId: String!, \$categoryName: String!, \$pageNo: Int!, \$noOfElements: Int!){
       getProductsByCategoryInBusiness(businessId:\$businessId, categoryName:\$categoryName,pageNo:\$pageNo,noOfElements:\$noOfElements){
       data {
       products{
        productName
        description
        quantity
        status
        price
        discount
        discountedPrice
        likedCount
        purchasedCount
        imagePaths
        listImagePath
       }
       totalPages
       }
  }
  }
  """;

  //get search product in business
  static String getSearchProductsInBusiness = """
  query searchProductsInBusiness(\$businessId: String!, \$productName: String!){
       searchProductsInBusiness(businessId:\$businessId, productName:\$productName){
       data {
       productsList{
       category{
       categoryName
       }
       products{
        productName
        description
        quantity
        status
        price
        discount
        discountedPrice
        likedCount
        purchasedCount
        imagePaths
        listImagePath
       }
       }
  }
  }
  }
  """;

  static String getAllServicesInBusiness = """
  query getAllServicesInBusiness(\$businessId: String!,\$pageNo: Int!,\$noOfElements: Int!){
    getAllServicesInBusiness(businessId:\$businessId, pageNo: \$pageNo, noOfElements: \$noOfElements){
    data{
      services{
        serviceName
        imagePaths
        listImagePath
        description
        status
        price
        availableSlots
        discount
        discountedPrice
        likedCount
        purchasedCount
      }
      totalPages
    }
    }
  }
  """;

  static String getSlotsByBusinessAndService = """
  query getSlotsByBusinessAndService(\$businessId: String!, \$date: String!, \$serviceName: String!, \$customerId: String!){
  getSlotsByBusinessAndService(businessId: \$businessId, date: \$date, serviceName: \$serviceName, customerId: \$customerId){
    data{
      slotNumber
      timeObj{
        startTime
        endTime
      }
      totalAvailable
      totalBooked
      bookedByUser
    }
    }
  }
  """;

  //search service in the business
  static String searchServicesInBusiness = """
  query searchServicesInBusiness(\$businessId: String!,\$ServiceName: String!){
    searchServicesInBusiness(businessId:\$businessId, ServiceName: \$ServiceName){
    data{
      services{
        serviceName
        imagePaths
        description
        status
        price
        availableSlots
        discount
        discountedPrice
        likedCount
        purchasedCount
      }
    }
    }
  }
  """;

  //get all products in business
  static String getAllProductsInBusiness = """
  query getAllProductsInBusiness(\$businessId: String!){
       getAllProductsInBusiness(businessId:\$businessId){
       data {
      products {
        productName
        imagePaths
        listImagePath
        quantity
      }
    }
  }
  }
  """;

  static String getAllBusiness = """
    query getAllBusiness{
  getAllBusiness{
    data{
    businessId
    businessDetails{
        inventoryList{
          products{
            imagePaths
          }
        }
      }
      isOpened
    timings {
      timings {
       monday {
        startTime
        endTime
      }
      tuesday {
        startTime
        endTime
      }
      wednesday { 
        startTime
        endTime
      }
      thursday {
        startTime
        endTime
      }
      friday {
        startTime
        endTime
      }
      saturday {
        startTime
        endTime
      }
      sunday {
        startTime
        endTime
      }
      }
     }
      businessInfo{
       name
       imagePath
       listImagePath
       address{
        street
        postalCode
        additionalAddress
        formatedAddress
        addressName
        residence
        area
        city
        province
        country
        latitude
        longitude
        addressType
       }
      }
    }
  }
}
  """;

  //get all shops search in business
  static String getBusinessByName = """
    query getBusinessByName(\$businessName: String!,\$pageNo: Int!,\$noOfElements: Int!){
  getBusinessByName(businessName:\$businessName, pageNo: \$pageNo, noOfElements: \$noOfElements){
    data{
    businessId
    businessDetails{
        inventoryList{
          products{
            imagePaths
          }
        }
      }
      isOpened
    timings {
      timings {
       monday {
        startTime
        endTime
      }
      tuesday {
        startTime
        endTime
      }
      wednesday { 
        startTime
        endTime
      }
      thursday {
        startTime
        endTime
      }
      friday {
        startTime
        endTime
      }
      saturday {
        startTime
        endTime
      }
      sunday {
        startTime
        endTime
      }
      }
     }
      businessInfo{
       name
       imagePath
       listImagePath
       address{
        street
        postalCode
        additionalAddress
        formatedAddress
        addressName
        residence
        area
        city
        province
        country
        latitude
        longitude
        addressType
       }
      }
    }
  }
}
  """;

  //get all shops who offer services
  static String getAllServices = """
    query getAllBusinessWhoOfferServices(\$pageNo: Int!,\$noOfElements: Int!){
  getAllBusinessWhoOfferServices(pageNo: \$pageNo,noOfElements: \$noOfElements){
    data{
    businessId
    businessDetails{
        servicesList{
        serviceName
        imagePaths
        description
        }
      }
      isOpened
    timings {
      timings {
       monday {
        startTime
        endTime
      }
      tuesday {
        startTime
        endTime
      }
      wednesday { 
        startTime
        endTime
      }
      thursday {
        startTime
        endTime
      }
      friday {
        startTime
        endTime
      }
      saturday {
        startTime
        endTime
      }
      sunday {
        startTime
        endTime
      }
      }
     }
      businessInfo{
       name
       imagePath
       listImagePath
       address{
        street
        postalCode
        additionalAddress
        formatedAddress
        addressName
        residence
        area
        city
        province
        country
        latitude
        longitude
        addressType
       }
      }
    }
  }
}
  """;

  //search shops name who offer services
  static String getShopByNameWhoProvideServices = """
    query getShopByNameWhoProvideServices(\$pageNo: Int!,\$noOfElements: Int!,\$businessName: String!){
  getShopByNameWhoProvideServices(pageNo: \$pageNo,noOfElements: \$noOfElements,businessName: \$businessName){
    data{
    businessId
    businessDetails{
        servicesList{
        serviceName
        imagePaths
        listImagePath
        description
        status
        price
        discountedPrice
        availableSlots
        discount
        likedCount
        purchasedCount
        }
      }
      isOpened
    timings {
      timings {
       monday {
        startTime
        endTime
      }
      tuesday {
        startTime
        endTime
      }
      wednesday { 
        startTime
        endTime
      }
      thursday {
        startTime
        endTime
      }
      friday {
        startTime
        endTime
      }
      saturday {
        startTime
        endTime
      }
      sunday {
        startTime
        endTime
      }
      }
     }
      businessInfo{
       name
       imagePath
       listImagePath
       address{
        street
        postalCode
        additionalAddress
        formatedAddress
        addressName
        residence
        area
        city
        province
        country
        latitude
        longitude
        addressType
       }
      }
    }
  }
}
  """;

  //create order for product
  static String createOrder = """
mutation createOrder(\$createOrderInput: CreateOrderInput){
     createOrder(input:\$createOrderInput){
     message
     status
     data {
     products{
     productName
     quantity
     price
     discount
     discountedPrice
     errorType
     updatedStock
     imagePaths
     previousQuantity
     }
     }
}
}
""";

  //create service
  static String createBookingServices = """
  mutation createBookingServices(\$userId: String!, \$CreateBookingInput: CreateBookingInput){
  createBookingServices(input: \$CreateBookingInput, userId: \$userId){
     data{
      bookingId
      status
    }
    status
    message
  }
  }
  """;

  //add to wishlist
  static String addToWishlist = """
  mutation addProductInWishList(\$userID: String!, \$categoryName: String!,\$AddProductInFavList: AddProductInFavList){
  addProductInWishList(input: \$AddProductInFavList, userID: \$userID, categoryName: \$categoryName){
   data{
      favouriteProducts{
        product{
        productName
        description
        quantity
        status
        price
        discount
        discountedPrice
        likedCount
        purchasedCount
        imagePaths
        listImagePath
       }
        business{
          businessInfo{
            name
            imagePath
            listImagePath
          }
        }
      }
    }
  }
  }
  """;

  //Delete to wishlist
  static String deleteProductFromWishList = """
  mutation deleteProductFromWishList(\$userID: String!, \$ProductInputs: ProductInputs,\$businessId: String!){
  deleteProductFromWishList(input: \$ProductInputs, userID: \$userID,businessId: \$businessId){
   data{
      favouriteProducts{
        product{
        productName
        description
        quantity
        status
        price
        discount
        discountedPrice
        likedCount
        purchasedCount
        imagePaths
        listImagePath
       }
        business{
          businessInfo{
            name
            imagePath
            listImagePath
          }
        }
      }
    }
  }
  }
  """;

  //add to wishlist
  static String getProductWishList = """
  query getProductWishList(\$userID: String!){
  getProductWishList(userID: \$userID){
    data{
      favouriteProducts{
        product{
          productName
          description
          quantity
          status
          price
          discount
          discountedPrice
          likedCount
          purchasedCount
          imagePaths
          listImagePath
        }
        business{
        businessId
          businessInfo{
            name
            imagePath
            listImagePath
          }
        }
      }
    }
    status
  }
  }
  """;

  //update user profile
  static String updateUserProfile = """
mutation updateUserProfile(\$UpdateUserProfile: UpdateUserProfile){
     updateUserProfile(input:\$UpdateUserProfile){
     message
     status
     data{
        userId
        phoneNumber
        status
        imagePath
        userName
        addresses{
        isActive
           address{
              street
              postalCode
              additionalAddress
              formatedAddress
              addressName
              residence
              area
              city
              province
              country
              latitude
              longitude
              addressType
           }
        }
        email
        name{
          firstName
          lastName
        }
    }
}
}
""";

  //get order by business query
  static String getOrdersByCustomerAndStatus = """
query getOrdersByCustomerAndStatus(\$customerId: String!,\$status: String!,\$pageNo: Int!,\$noOfElements: Int!){
     getOrdersByCustomerAndStatus(customerId: \$customerId,status: \$status,pageNo: \$pageNo,noOfElements: \$noOfElements){
     data { 
     address {
      street
      postalCode
      additionalAddress
      formatedAddress
      addressName
      residence
      area
      city
      province
      country
      latitude
      longitude
      addressType
    }
     customer {
      name {
      firstName
        lastName
      }
      phoneNumber
      email
    }
    orderId
    business{
       businessInfo{
        name
        imagePath
        listImagePath
      }
        users{
        imagePath
         name{
          firstName
          lastName
        }
        }
      }
  orderType
    orderDetails {
      productCartItems {
        productName
        quantity
        price
        discount
        discountedPrice
      }
      totalAmount
      instructions
      rating
    }
    status
    
  }
  message
     status
     totalPages
}
}
""";

  //get service bookings by business query
  static String getBookingsByCustomerIdAndStatus = """
  query getBookingsByCustomerIdAndStatus(\$pageNo: Int!, \$noOfElements: Int!, \$customerId: String!, \$statusType: String!){
  getBookingsByCustomerIdAndStatus(pageNo: \$pageNo, noOfElements: \$noOfElements, customerId: \$customerId, statusType: \$statusType){
   data{
      bookingId
      business{
        users{
          name{
            firstName
            lastName
          }
          imagePath
        }
        businessInfo{
          name
          imagePath
          listImagePath
        }
      }
      bookingDetails{
        serviceCartItems{
          serviceName
          price
          discount
          discountedPrice
        }
        slotNumber
        timeObj{
          startTime
          endTime
        }
        totalAmount
      }
    }
    totalPages
  }
  }
  """;


  //get shops according to the address
  static String calculateBusinessesWithinRange = """
  query calculateBusinessesWithinRange(\$userId: String!){
  calculateBusinessesWithinRange(userId: \$userId){
  data{
        businesses{
          businessId
    businessDetails{
        inventoryList{
          products{
            imagePaths
          }
        }
        servicesList {
            serviceName
            imagePaths
            description
            status
            price
            availableSlots
            discount
            discountedPrice
            likedCount
            purchasedCount
          }
      }
      isOpened
    timings {
      timings {
       monday {
        startTime
        endTime
      }
      tuesday {
        startTime
        endTime
      }
      wednesday { 
        startTime
        endTime
      }
      thursday {
        startTime
        endTime
      }
      friday {
        startTime
        endTime
      }
      saturday {
        startTime
        endTime
      }
      sunday {
        startTime
        endTime
      }
      }
     }
      businessInfo{
       name
       imagePath
       listImagePath
       address{
        street
        postalCode
        additionalAddress
        formatedAddress
        addressName
        residence
        area
        city
        province
        country
        latitude
        longitude
        addressType
       }
      }
        }
        }
  }
  }
  """;

  static String updateUserAddressStatus = """
  mutation updateUserAddressStatus(\$userId: String!, \$index: Int!){
  updateUserAddressStatus(userId: \$userId, index: \$index){
   data{
        userId
        phoneNumber
        status
        imagePath
        userName
        addresses{
          isActive
          address{
            street
            postalCode
            additionalAddress
            formatedAddress
            addressName
            residence
            area
            city
            province
            country
            latitude
            longitude
            addressType
          }
        }
        email
        name{
          firstName
          lastName
        }
        }
  }
  }
  """;

  //update Fcm query
  static String updateFCM = """
  query updateFCM(\$FCMToken: String!,\$isCustomerApp:Boolean!){
       updateFCM(FCMToken:\$FCMToken,isCustomerApp:\$isCustomerApp)
  }
  """;
}
