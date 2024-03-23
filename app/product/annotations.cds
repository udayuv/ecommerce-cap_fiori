using ProcessorService as service from '../../srv/cds/productService';

annotate service.Products with @(
    odata.draft.enabled : true,
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : '{i18n>prd_name}',
            Value : name,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>prd_desc}',
            Value : description,
        },
        {
            $Type : 'UI.DataField',
            Value : category.name,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>Price}',
            Value : price,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>Stock}',
            Value : stock,
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.DataPoint#rating',
        },
    ]
);
annotate service.Products with @(
    UI.FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'name',
                Value : name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'description',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Label : 'price',
                Value : price,
            },
            {
                $Type : 'UI.DataField',
                Label : 'rating',
                Value : rating,
            },
            {
                $Type : 'UI.DataField',
                Label : 'stock',
                Value : stock,
            },
            {
                $Type : 'UI.DataField',
                Label : 'images',
                Value : images,
            },
            {
                $Type : 'UI.DataField',
                Label : 'discount',
                Value : discount,
            },
            {
                $Type : 'UI.DataField',
                Label : 'thumbnail',
                Value : thumbnail,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup1',
        },
    ]
);
annotate service.Products with @(
    UI.SelectionFields : [
        rating,
        discount,
        category_ID,
    ]
);
annotate service.Products with {
    rating 
    @Common.Label : '{i18n>Rating}';

    discount 
    @Common.Label : '{i18n>Discount}';

    category 
    @Common.Label : '{i18n>Category}'
};

annotate service.Category with {
    ID 
    @Common.Label : '{i18n>cat_id}';

    name 
    @Common.Label : '{i18n>cat_name}';

};

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
annotate service.Products with @(
    UI.DataPoint #rating : {
        Value : rating,
        Visualization : #Rating,
        TargetValue : 5,
    }
);
