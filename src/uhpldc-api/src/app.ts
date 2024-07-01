import express from 'express';
import dotenv from 'dotenv';
import synapseRoutes from './routes/v1/synapse-routes';

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.use('/api/v1/synapse', synapseRoutes);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});