import mongoose, { Document, Schema } from 'mongoose';
import {mongoosePagination, Pagination} from 'mongoose-paginate-ts';

export interface IProduct {
    name: string;
    description: string;
    price: number;
    units: number;
}

export interface IProductModel extends IProduct, Document {}

const ProductSchema: Schema = new Schema(
    {
        name: { type: String, required: true },
        description: { type: String, required: true },
        price: { type: Number, required: true },
        units: { type: Number, required: true }
    },
    {
        versionKey: false
    }
);

ProductSchema.plugin(mongoosePagination);
export default mongoose.model<IProductModel, Pagination<IProductModel>>('Product', ProductSchema);
