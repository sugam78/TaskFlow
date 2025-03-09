const jwt = require("jsonwebtoken");

const auth = async(req,res,next)=>{
    try{
        const token = req.header("Authorization").replace("Bearer ", "");
        if(!token){
            res.status(401).json({error: "No auth token, Access denied"});
        }
        const verify = jwt.verify(token,"passwordKey");
        if(!verify){
            return res.status(401).json({error:'Token verification failed, authorization denied'});
        }
        req.user = verify.id;
        req.token = token;
        next();
    }
    catch(e){
        res.status(500).json({error: e.message});
    }
}

module.exports = auth;