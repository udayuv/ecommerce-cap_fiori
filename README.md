# ecommerce-cap_fiori 
For references [SAP GIT Rep](https://github.com/SAP-samples)

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
```cds
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
```cds
using { sap.ecom.product as ecom } from '../../db/index';

service ProcessorService { 
    entity Products as projection on ecom.Product;
    entity Category as projection on ecom.Category;
}

```

#### Generate comma-separated values (CSV) templates
-   Generate comma-separated values (CSV) templates using command `cds add data`, it will create csv templates, here you can add test data to verify
-   Also the template will by default bring every column, if you don't want to provide value to the column remove it, and keep the one which shouldn't be null

### 03 Generate the UI with an SAP Fiori Elements template
-   In windows open Command Palette quickly using the following key combination: `Ctrl + Shift + P`
-  Type Fiori: **Open Application Generator** in the field and select this entry from the list.
-   In the Template Selection step:
    -   In the Template Type dropdown menu, select **SAP Fiori**. Then, choose the **List Report Page template** tile.
    -   Choose **Next**.
-   In the **Data Source and Service Selection** step:
    -   In the **Data source** dropdown menu, select **Use a Local CAP Project**.
    -   In the Choose your CAP project dropdown menu, select the **ecom-app** project.
    -   In the **OData service** dropdown menu, select the **ProductService (Java)**.
    -   Choose **Next**.
-   In the **Entity Selection** step:
    -   In the **Main entity** dropdown menu, select **Products**.
    -   Leave the **Navigation entity** value as **none**, and then select **Yes** to add table columns automatically.
    -   Choose **Next**.
-   In the **Project Attributes** step:
    -   In the **Module name** field, enter **products**.
    -   In the **Application title** field, enter **Products**.
    -   In the **Application** namespace field, enter **ns**.
    -   Leave the default values for all the other settings and choose **Finish**.

The application is now generated and in a few seconds you can see the application’s **product** folder in the app folder of your **ecom-app** project. It contains a **webapp** folder with a **Component.js** file that is typical for an **SAPUI5** application. However, the source code of this application is minimal. 
It inherits its logic from the **sap/fe/core/AppComponent** class. This class is managed centrally by SAP Fiori elements and provides all the services that are required (routing, edit flow) so that the building blocks and the templates work properly.

