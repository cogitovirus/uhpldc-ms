import express from 'express';
import * as synapseService from '../../services/synapse-service';

const router = express.Router();

router.get('/workspaces', async (req, res) => {
  try {
    const workspace = await synapseService.getWorkspaces();
    res.json(workspace);
  } catch (error) {
    res.status(500).json({ error: 'Error fetching workspace' });
  }
});

router.get('/sqlpools', async (req, res) => {
  try {
    const sqlPools = await synapseService.listSqlPools();
    res.json(sqlPools);
  } catch (error) {
    res.status(500).json({ error: 'Error fetching SQL pools' });
  }
});

export default router;