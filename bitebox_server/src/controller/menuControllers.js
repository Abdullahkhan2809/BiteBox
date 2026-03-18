const db=require('../config/db')

exports.getAllmenuItems= async (req,res) =>{
    try {
        const result = await db.query('SELECT * FROM menu_items WHERE is_available = true ORDER BY category');
        res.status(200).json(result.rows);
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: "Server error while fetching menu." });
    }
}