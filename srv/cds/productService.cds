using { sap.ecom.product as ecom } from '../../db/index';

service ProcessorService { 
    entity Products as projection on ecom.Product;
    entity Category as projection on ecom.Category;
}
