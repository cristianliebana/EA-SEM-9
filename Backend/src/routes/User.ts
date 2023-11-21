import express from 'express';
import controller from '../controllers/User';
import { Schemas, ValidateSchema } from '../middleware/ValidateSchema';

const router = express.Router();

router.post('/createuser', ValidateSchema(Schemas.user.create), controller.createUser);
router.get('/readuser/:userId', controller.readUser);
router.get('/readall', controller.readAll);
router.put('/updateuser/:userId', ValidateSchema(Schemas.user.update), controller.updateUser);
router.delete('/deleteuser/:userId', controller.deleteUser);

export = router;
