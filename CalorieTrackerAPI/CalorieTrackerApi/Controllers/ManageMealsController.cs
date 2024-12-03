using IncomeTallyAPI.Repositories;
using Common.CommConstants;
using Common.Entities;
using Microsoft.AspNetCore.Mvc;

namespace IncomeTallyAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ManageMealsController : ControllerBase
    {
        private readonly MealRepository _mealsRepo;

        public ManageMealsController()
        {
            _mealsRepo = new MealRepository();
        }

        [HttpPost]
        public async Task<IActionResult> CreateMeal([FromBody] CreateMealRequest request)
        {
            try
            {
                var meal = new Meal(request.Title, request.Calories, request.Carbs, request.Protein, request.Fat);
                _mealsRepo.Save(meal);

                var response = GenerateResponse(meal);
                return CreatedAtAction(nameof(GetMeal), new { id = meal.Id }, response);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { error = "An error occurred while processing your request.", details = ex.Message });
            }
        }

        // Retrieve by ID
        [HttpGet("{id}")]
        public IActionResult GetMeal(int id)
        {
            try
            {
                var meal = _mealsRepo.GetAll(n => n.Id == id).Find(i => i.Id == id);
                if (meal == null)
                {
                    return NotFound();
                }

                var response = GenerateResponse(meal);
                return Ok(response);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { error = "An error occurred while processing your request.", details = ex.Message });
            }
        }

        // Retrieve all
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            try
            {
                var allMeals = _mealsRepo.GetAll(i => true);
                var response = allMeals.Select(expense => GenerateResponse(expense)).ToList();

                //Simulate delay
                await Task.Delay(1000);
                return Ok(response);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { error = "An error occurred while processing your request.", details = ex.Message });
            }
        }

        // Update
        [HttpPut("{id}")]
        public IActionResult UpdateExpense(int id, [FromBody] UpdateMealRequest request)
        {
            try
            {
                var meal = _mealsRepo.GetAll(n => n.Id == id).Find(i => i.Id == id);
                if (meal == null)
                {
                    return NotFound();
                }

                meal.Title = request.Title;
                meal.Calories = request.Calories;
                meal.Carbs = request.Carbs;
                meal.Protein = request.Protein;
                meal.Fat = request.Fat;

                _mealsRepo.Save(meal);
                return new JsonResult(Ok());
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { error = "An error occurred while processing your request.", details = ex.Message });
            }
        }

        // Delete
        [HttpDelete("{id}")]
        public IActionResult DeleteMeal(int id)
        {
            try
            {
                var meal = _mealsRepo.GetAll(n => n.Id == id).Find(i => i.Id == id);
                if (meal == null)
                {
                    return NotFound();
                }

                _mealsRepo.Delete(meal);
                return Ok();
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { error = "An error occurred while processing your request.", details = ex.Message });
            }
        }

        [HttpGet("search/{filter}/{searchWord}")]
        public IActionResult SearchExpensesByDetails(string filter, string searchWord)
        {
            try
            {
                List<Meal> mealsSearchResult;
                mealsSearchResult = _mealsRepo.GetAll(n => n.Title.ToUpper().Replace(" ", "").Contains(searchWord.ToUpper()));

                var response = mealsSearchResult.Select(meal => GenerateResponse(meal)).ToList();
                return Ok(response);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { error = "An error occurred while processing your request.", details = ex.Message });
            }
        }

        private MealResponse GenerateResponse(Meal meal)
        {
            return new MealResponse
            {
                Id = meal.Id,
                Title = meal.Title,
                Calories = meal.Calories,
                Carbs = meal.Carbs,
                Protein = meal.Protein,
                Fat = meal.Fat,
            };
        }
    }
}
