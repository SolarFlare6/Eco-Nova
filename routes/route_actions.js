//Action routes
const{postEcoAction,getEcoAction,getEcoTopContributors, todaysAchievements}=require('../controllers/controller_actions');
const router=require('express').Router();
router.post('/create-action',postEcoAction)
router.get('/actions',getEcoAction);
router.get('/topContributors',getEcoTopContributors);
router.get('/todaysAchievements',todaysAchievements);