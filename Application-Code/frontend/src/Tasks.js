import { Component } from "react";
import {
    addTask,
    getTasks,
    updateTask,
    deleteTask,
} from "./services/taskServices";

class Tasks extends Component {
    state = { tasks: [], currentTask: "" };

    async componentDidMount() {
        try {
            const { data } = await getTasks();
            this.setState({ tasks: data });
        } catch (error) {
            this.setState({ error: "Unable to load tasks. Please try again." });
        }
    }

    handleChange = ({ currentTarget: input }) => {
        this.setState({ currentTask: input.value });
    };

    handleSubmit = async (e) => {
        e.preventDefault();
        const taskText = this.state.currentTask.trim();
        if (!taskText) {
            this.setState({ error: "Enter a task before adding it." });
            return;
        }
        try {
            const { data } = await addTask({ task: taskText });
            this.setState((state) => ({
                tasks: [...state.tasks, data],
                currentTask: "",
                error: "",
            }));
        } catch (error) {
            this.setState({ error: "Unable to add the task. Please try again." });
        }
    };

    handleUpdate = async (currentTask) => {
        const originalTasks = this.state.tasks;
        try {
            const tasks = [...originalTasks];
            const index = tasks.findIndex((task) => task._id === currentTask);
            if (index === -1) {
                return;
            }
            tasks[index] = { ...tasks[index] };
            tasks[index].completed = !tasks[index].completed;
            this.setState({ tasks });
            await updateTask(currentTask, {
                completed: tasks[index].completed,
            });
        } catch (error) {
            this.setState({ tasks: originalTasks, error: "Unable to update the task. Please try again." });
        }
    };

    handleDelete = async (currentTask) => {
        const originalTasks = this.state.tasks;
        try {
            const tasks = originalTasks.filter(
                (task) => task._id !== currentTask
            );
            this.setState({ tasks });
            await deleteTask(currentTask);
        } catch (error) {
            this.setState({ tasks: originalTasks, error: "Unable to delete the task. Please try again." });
        }
    };
}

export default Tasks;
