# ecommerce-cap_fiori

### create project and push to an existing repository from the command line
```
echo "# ecommerce-cap_fiori" >> README.md
git init
git remote add origin https://github.com/udayuv/ecommerce-cap_fiori.git
git branch -M master
git push -u origin master
```
### Creating Base CAP template ([Sample Guide](https://developers.sap.com/group.cap-application-full-stack.html))
used the below command to create base template for cap java application. Create a new project using `cds init`
```
cds init ecom-app
```
This command creates a folder ecom-app with your newly created CAP project.
While you are in the ecom-app folder, Now you can use the terminal to start a CAP server using `cds watch`