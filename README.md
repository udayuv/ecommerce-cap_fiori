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

### 04 Configure the List View Page
To add adapt filter on list page we use `SelectionFields` on the entity to which we want to add, here we have used Products
```cds
annotate service.Products with @(
    UI.SelectionFields : [
        rating,
        discount,
        category_ID,
    ]
);
```
Similarly to add i18n language have given the label

```cds
annotate service.Products with {
    rating 
    @Common.Label : '{i18n>Rating}';

    discount 
    @Common.Label : '{i18n>Discount}';

    category 
    @Common.Label : '{i18n>Category}'
};
```
Now have added the value help in Category field and annotated with ValueList
-   **ValueListParameterOut:** Fields based on this property get auto populated based on the selected valuehelp option
-   **ValueListParameterIn:** Value selected in fields based on this property filter out the possible valuehelp option
-   **ValueListParameterInOut:** Combines the effect of both in and out
-   **CollectionPath** : refers to the entity how fields are managed there

```cds
annotate service.Products with {
    category @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Category',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : category_ID,
                    ValueListProperty : 'ID',
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    ValueListProperty : 'name',
                    LocalDataProperty : category.name,
                },
            ],
        },
        Common.ValueListWithFixedValues : false
)};
```
To show the column names in english added i18n to Category entity as values help is on category entity
```cds
annotate service.Category with {
    ID 
    @Common.Label : '{i18n>cat_id}';

    name 
    @Common.Label : '{i18n>cat_name}';

};
```
### 05 Added Rating
Since we want to add Rating in our list table hence added this
```cds
{
    $Type : 'UI.DataFieldForAnnotation',
    Target : '@UI.DataPoint#rating',
}
```
here  we have kept the type as DataFieldForAnnotation and target is pointing to a Datapoint which is on product and used for Visualization of a single point of data, typically a number; may also be textual, e.g. a status value
for more info [DataPointType](https://github.com/SAP/odata-vocabularies/blob/8d9f4484c4b47d80faf090abecfa184dcc4468b7/vocabularies/UI.md#DataPointType)

```cds
annotate service.Products with @(
    UI.DataPoint #rating : {
        Value : rating,
        Visualization : #Rating,
        TargetValue : 5,
    }
);
```

### 06 Enable Draft
By enabling draft we can get extra filter on ui as Editig status which will give multiple option to filter out the list,
Whether it is locked or in draft mode, etc
```cds
annotate service.Products with @(
    odata.draft.enabled : true,
    UI.LineItem : [
    ...
```