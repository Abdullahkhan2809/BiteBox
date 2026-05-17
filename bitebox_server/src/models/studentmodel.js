const db = require('../config/db');

// find student by cms_id
const findStudent = async (cmsId) => {
  const result = await db.query(
    'SELECT * FROM students WHERE cms_id = $1',
    [cmsId]
  );
  return result.rows[0] || null;
};

// create student on first login (lazy auth)
const createStudent = async (cmsId, universityId) => {
  const result = await db.query(
    `INSERT INTO students (cms_id, university_id, name)
     VALUES ($1, $2, $3)
     RETURNING *`,
    [cmsId, universityId, cmsId] // name defaults to cmsId until updated
  );
  return result.rows[0];
};

// find or create — the lazy auth core logic
const findOrCreate = async (cmsId, universityId) => {
  let student = await findStudent(cmsId);
  if (!student) {
    student = await createStudent(cmsId, universityId);
  }
  return student;
};

module.exports = { findStudent, createStudent, findOrCreate };