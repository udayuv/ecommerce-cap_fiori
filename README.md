# ecommerce-cap_fiori

### create project and push to an existing repository from the command line
```
echo "# ecommerce-cap_fiori" >> README.md
git init
git remote add origin <repo path>
git branch -M master
git push -u origin master
```
### Creating Base CAP template ([Sample Guide](https://developers.sap.com/group.cap-application-full-stack.html))
used the below command to create base template for cap java application. Create a new project using `cds init`
```
cds init ecom-app --add java
```
This command creates a folder ecom-app with your newly created CAP project.
While you are in the ecom-app folder, Now you can use the terminal to start a CAP server using `cds watch`

### 01 Creating Models
In the db folder, create a new schema.cds file.
For me i want to create in a structured manner hence created a folder product and inside that product.cds
And to make it accessible have created index.cds in db folder which uses product/index.cds and product/index.cds uses product.cds

Paste the following code snippet in the product.cds file.
```
namespace sap.ecom.product; 

using {cuid, managed} from '@sap/cds/common';

/**
 * Product 
 */
entity Product : cuid,managed{
    name        :   Name;
    description :   Description;
    price       :   String;
    rating      :   Decimal;
    stock       :   Integer;
    category    :   Association to Category;
    images      :   ImageLink;
    discount    :   Decimal;
    thumbnail   :   ImageLink;
}

/**
 * Category for Products
 */
entity Category : cuid,managed{
    name    :   Name;
    product :   Association to many Product on product.category = $self;
}

/**
 * Common Datatype for Product and Category
 */
type Name           :   String(30);
type Description    :   String(1000);
type ImageLink      :   String(100);
```

### 02 Adding Service creating csv file
#### Creating Service
-   It’s a good practice in CAP to create single-purpose services. Hence, let’s define a ProductService to show product list to customers.
-   To create the service definition:
-   In the srv folder, create a new processor-service.cds file. or if you want to organize in folder follow the steps as i have done in db folder for schema
-   Paste the following code snippet in the productService.cds file:
```
using { sap.ecom.product as ecom } from '../../db/index';

service ProcessorService { 
    entity Products as projection on ecom.Product;
    entity Category as projection on ecom.Category;
}

```

#### Generate comma-separated values (CSV) templates
-   Generate comma-separated values (CSV) templates using command `cds add data`, it will create csv templates, here you can add test data to verify
-   Also the template will by default bring every column, if you don't want to provide value to the column remove it, and keep the one which shouldn't be null
