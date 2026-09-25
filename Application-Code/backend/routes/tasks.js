const Task = require("../models/task");
const express = require("express");
const router = express.Router();

router.post("/", async (req, res) => {
    try {
        if (!req.body.task || !req.body.task.trim()) {
            return res.status(400).json({ error: "Task text is required." });
        }
        const task = await new Task(req.body).save();
        res.status(201).json(task);
    } catch (error) {
        res.status(500).json({ error: "Unable to create task." });
    }
});

router.get("/", async (req, res) => {
    try {
        const tasks = await Task.find();
        res.json(tasks);
    } catch (error) {
        res.status(500).json({ error: "Unable to load tasks." });
    }
});

router.put("/:id", async (req, res) => {
    try {
        const task = await Task.findOneAndUpdate(
            { _id: req.params.id },
            req.body,
            { new: true, runValidators: true }
        );
        if (!task) {
            return res.status(404).json({ error: "Task not found." });
        }
        res.json(task);
    } catch (error) {
        res.status(400).json({ error: "Unable to update task." });
    }
});

router.delete("/:id", async (req, res) => {
    try {
        const task = await Task.findByIdAndDelete(req.params.id);
        if (!task) {
            return res.status(404).json({ error: "Task not found." });
        }
        res.json(task);
    } catch (error) {
        res.status(400).json({ error: "Unable to delete task." });
    }
});

module.exports = router;
