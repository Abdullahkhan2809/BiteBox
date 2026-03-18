const express= require('express');
const router=express.Router();
const menuController=require('../controller/menuControllers')

router.get('/',menuController.getAllmenuItems);
module.exports=router;
